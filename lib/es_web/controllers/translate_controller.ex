defmodule EsWeb.TranslateController do
  use EsWeb, :controller

  alias Es.Translations
  alias Es.Translations.Translate

  action_fallback EsWeb.FallbackController

  @spec create(any, map) :: any
  def create(conn, %{"translate" => translate_params}) do
    with {:ok, %Translate{} = translate} <- Translations.create_translate(translate_params) do
      conn
      |> put_status(:created)
      |> render("show.json", translate: translate)
    end
  end

  def find(conn, %{"source" => source, "source_lang" => source_lang, "target_lang" => target_lang}) do
    translate = Translations.get_translate(source, source_lang, target_lang)
    render(conn, "show.json", translate: translate)
  end
end
