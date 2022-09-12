defmodule Es.TranslationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Es.Translations` context.
  """

  @doc """
  Generate a translate.
  """
  def translate_fixture(attrs \\ %{}) do
    {:ok, translate} =
      attrs
      |> Enum.into(%{
        source_lang: "some source_lang",
        target_lang: "some target_lang",
        translation: %{}
      })
      |> Es.Translations.create_translate()

    translate
  end
end
