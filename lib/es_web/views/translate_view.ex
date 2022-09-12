defmodule EsWeb.TranslateView do
  use EsWeb, :view
  alias EsWeb.TranslateView

  def render("index.json", %{translations: translations}) do
    %{data: render_many(translations, TranslateView, "translate.json")}
  end

  def render("show.json", %{translate: translate}) do
    %{data: render_one(translate, TranslateView, "translate.json")}
  end

  def render("translate.json", %{translate: translate}) do
    %{
      id: translate.id,
      source_lang: translate.source_lang,
      target_lang: translate.target_lang,
      translation: translate.translation
    }
  end
end
