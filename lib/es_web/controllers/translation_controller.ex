defmodule EsWeb.TranslationController do
  use EsWeb, :controller

  alias Es.Translations
  alias Es.Translations.Translation

  action_fallback EsWeb.FallbackController

  @spec create(any, map) :: any
  def create(conn, %{"translate" => translation_params}) do
    with {:ok, %Translation{} = translation} <-
           Translations.create_translation(translation_params) do
      conn
      |> put_status(:created)
      |> render("show.json", translation: translation)
    end
  end

  @spec find(Plug.Conn.t(), map) :: Plug.Conn.t()
  def find(conn, %{"source" => source, "source_lang" => source_lang, "target_lang" => target_lang}) do
    translation = Translations.get_translation(source, source_lang, target_lang)
    render(conn, "show.json", translation: translation)
  end
end
