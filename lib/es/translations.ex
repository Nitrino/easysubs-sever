defmodule Es.Translations do
  @moduledoc """
  The Translations context.
  """

  import Ecto.Query, warn: false
  alias Es.Repo

  alias Es.Translations.Translate

  @doc """
  Gets a single translate.

  Returns nil if the Translate does not exist.

  ## Examples

      iex> get_translate("word", "en", "ru)
      %Translate{}

      iex> get_translate("unknown_word", "en", "ru)
      nil

  """
  @spec get_translate(binary(), binary(), binary()) :: %Translate{} | nil
  def get_translate(source, source_lang, target_lang) do
    Repo.one(
      from t in Translate,
        where:
          t.source == ^source and t.source_lang == ^source_lang and
            t.target_lang == ^target_lang
    )
  end

  @doc """
  Creates a translate.

  ## Examples

      iex> create_translate(%{field: value})
      {:ok, %Translate{}}

      iex> create_translate(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_translate(attrs \\ %{}) do
    %Translate{}
    |> Translate.changeset(attrs)
    |> Repo.insert()
  end
end
