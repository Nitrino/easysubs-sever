defmodule EsWeb.TranslationView do
  use EsWeb, :view
  alias EsWeb.TranslationView

  def render("index.json", %{translations: translations}) do
    %{data: render_many(translations, TranslationView, "translation.json")}
  end

  def render("show.json", %{translation: translation}) do
    %{data: render_one(translation, TranslationView, "translation.json")}
  end

  def render("translation.json", %{translation: translation}) do
    %{
      id: translation.id,
      source: translation.source,
      source_lang: translation.source_lang,
      target_lang: translation.target_lang,
      quick_translations: translation.quick_translations,
      full_translations: translation.full_translations,
      examples: translation.examples
    }
  end
end
