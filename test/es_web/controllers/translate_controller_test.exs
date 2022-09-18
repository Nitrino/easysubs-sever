defmodule EsWeb.TranslationControllerTest do
  use EsWeb.ConnCase

  import Es.TranslationsFixtures

  alias Es.Translations.Translate

  @create_attrs %{
    source_lang: "some source_lang",
    target_lang: "some target_lang",
    translation: %{}
  }
  @update_attrs %{
    source_lang: "some updated source_lang",
    target_lang: "some updated target_lang",
    translation: %{}
  }
  @invalid_attrs %{source_lang: nil, target_lang: nil, translation: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all translations", %{conn: conn} do
      conn = get(conn, Routes.translate_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create translate" do
    test "renders translate when data is valid", %{conn: conn} do
      conn = post(conn, Routes.translate_path(conn, :create), translate: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.translate_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "source_lang" => "some source_lang",
               "target_lang" => "some target_lang",
               "translation" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.translate_path(conn, :create), translate: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update translate" do
    setup [:create_translate]

    test "renders translate when data is valid", %{
      conn: conn,
      translate: %Translate{id: id} = translate
    } do
      conn = put(conn, Routes.translate_path(conn, :update, translate), translate: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.translate_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "source_lang" => "some updated source_lang",
               "target_lang" => "some updated target_lang",
               "translation" => %{}
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, translate: translate} do
      conn = put(conn, Routes.translate_path(conn, :update, translate), translate: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete translate" do
    setup [:create_translate]

    test "deletes chosen translate", %{conn: conn, translate: translate} do
      conn = delete(conn, Routes.translate_path(conn, :delete, translate))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.translate_path(conn, :show, translate))
      end
    end
  end

  defp create_translate(_) do
    translate = translate_fixture()
    %{translate: translate}
  end
end
