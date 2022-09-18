defmodule Es.Translations do
  @moduledoc """
  The Translations context.
  """

  import Ecto.Query, warn: false
  import Es.Utils
  alias Es.Repo

  alias Es.Translations.Translation

  @doc """
  Gets a single translation.

  Returns nil if the Translation does not exist.

  ## Examples

      iex> get_translation("word", "en", "ru)
      %Translation{}

      iex> get_translation("unknown_word", "en", "ru)
      nil

  """
  @spec get_translation(binary(), binary(), binary()) :: %Translation{} | nil
  def get_translation(source, source_lang, target_lang) do
    response =
      Repo.one(
        from t in Translation,
          select: %{
            translation: t,
            rank:
              fragment(
                "GREATEST(similarity(source, ?)) AS rank",
                ^source
              )
          },
          where:
            t.source_lang == ^source_lang and
              t.target_lang == ^target_lang and
              fragment(
                "ts @@ to_tsquery('english', ?)",
                ^prefix_search(source)
              ),
          order_by: fragment("rank DESC"),
          limit: 1
      )

    case response do
      nil -> nil
      %{translation: translation} -> translation
    end
  end

  @doc """
  Creates a translate.

  ## Examples

      iex> create_translation(%{field: value})
      {:ok, %Translation{}}

      iex> create_translation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_translation(attrs \\ %{}) do
    %{
      quick_translations: quick_translations,
      examples: examples,
      full_translations: full_translations
    } = convert_translation(attrs["translation"])

    attrs = Map.put(attrs, "quick_translations", quick_translations)
    attrs = Map.put(attrs, "examples", examples)

    %Translation{}
    |> Translation.changeset(attrs)
    |> Ecto.Changeset.put_embed(:full_translations, full_translations)
    |> Repo.insert()
  end

  defp prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"

  defp convert_translation(translation) do
    quick_translations_raw =
      translation
      |> dig(["translate", 1, 0, 0, 5, 0, 4])

    quick_translations =
      case quick_translations_raw do
        nil -> []
        quick_translations_raw -> Enum.map(quick_translations_raw, fn t -> dig(t, [0]) end)
      end

    definitions_raw = dig(translation, ["translate", 3, 1, 0])

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

    full_translations_raw = dig(translation, ["translate", 3, 5, 0])

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

    examples_raw = dig(translation, ["translate", 3, 2, 0])

    examples =
      case examples_raw do
        nil ->
          []

        examples_raw ->
          examples_raw
          |> List.flatten()
          |> Enum.reject(&is_nil/1)
      end

    %{
      quick_translations: quick_translations,
      examples: examples,
      full_translations: full_translations
    }
  end
end
