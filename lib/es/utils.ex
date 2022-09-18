defmodule Es.Utils do
  alias Es.Repo
  alias Es.Translations.Translation

  @spec dig(map() | list(), list()) :: any()
  def dig(data, keys)

  def dig(nil, _) do
    nil
  end

  def dig(data, [key | keys]) when is_map(data) do
    dig(Map.get(data, key), keys)
  end

  def dig(data, [key | keys]) when is_list(data) do
    dig(Enum.at(data, key), keys)
  end

  def dig(data, []) do
    data
  end

  def convert do
    Repo.all(Translation)
    |> Enum.each(fn t ->
      IO.inspect("word `#{t.source}` started")

      quick_translations_raw =
        t.translation
        |> dig(["translate", 1, 0, 0, 5, 0, 4])

      quick_translations =
        case quick_translations_raw do
          nil -> []
          quick_translations_raw -> Enum.map(quick_translations_raw, fn t -> dig(t, [0]) end)
        end

      definitions_raw = dig(t.translation, ["translate", 3, 1, 0])

      definitions =
        case definitions_raw do
          nil ->
            []

          definitions_raw ->
            definitions_raw
            |> Enum.map(fn t ->
              %{
                part_of_speach: dig(t, [0]),
                info:
                  dig(t, [1])
                  |> Enum.map(fn m ->
                    %{
                      meaning: dig(m, [0]),
                      example: dig(m, [1]),
                      synonyms: (dig(m, [5]) || []) |> List.flatten()
                    }
                  end)
              }
            end)
        end

      full_translations_raw = dig(t.translation, ["translate", 3, 5, 0])

      full_translations =
        case full_translations_raw do
          nil ->
            []

          translations ->
            Enum.map(translations, fn t ->
              part_of_speech = dig(t, [0])

              %{
                part_of_speech: part_of_speech,
                items:
                  dig(t, [1])
                  |> Enum.map(fn tv ->
                    %{
                      word: dig(tv, [0]),
                      translations: dig(tv, [2]),
                      popularity: 4 - dig(tv, [3]),
                      definitions:
                        definitions
                        |> Enum.find(fn v -> v.part_of_speach == part_of_speech end)
                        |> dig([:info]) || []
                    }
                  end)
              }
            end)
        end

      examples_raw = dig(t.translation, ["translate", 3, 2, 0])

      examples =
        case examples_raw do
          nil ->
            []

          examples_raw ->
            examples_raw
            |> List.flatten()
            |> Enum.reject(&is_nil/1)
        end

      changeset =
        t
        |> Translation.changeset(%{
          quick_translations: quick_translations,
          examples: examples
        })

      changeset = Ecto.Changeset.put_embed(changeset, :full_translations, full_translations)
      Repo.update!(changeset)

      IO.inspect("word `#{t.source}` updated")
    end)
  end
end
