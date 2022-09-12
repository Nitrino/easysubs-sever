defmodule Es.TranslationsTest do
  use Es.DataCase

  alias Es.Translations

  describe "translations" do
    alias Es.Translations.Translate

    import Es.TranslationsFixtures

    @invalid_attrs %{source_lang: nil, target_lang: nil, translation: nil}

    test "list_translations/0 returns all translations" do
      translate = translate_fixture()
      assert Translations.list_translations() == [translate]
    end

    test "get_translate!/1 returns the translate with given id" do
      translate = translate_fixture()
      assert Translations.get_translate!(translate.id) == translate
    end

    test "create_translate/1 with valid data creates a translate" do
      valid_attrs = %{source_lang: "some source_lang", target_lang: "some target_lang", translation: %{}}

      assert {:ok, %Translate{} = translate} = Translations.create_translate(valid_attrs)
      assert translate.source_lang == "some source_lang"
      assert translate.target_lang == "some target_lang"
      assert translate.translation == %{}
    end

    test "create_translate/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Translations.create_translate(@invalid_attrs)
    end

    test "update_translate/2 with valid data updates the translate" do
      translate = translate_fixture()
      update_attrs = %{source_lang: "some updated source_lang", target_lang: "some updated target_lang", translation: %{}}

      assert {:ok, %Translate{} = translate} = Translations.update_translate(translate, update_attrs)
      assert translate.source_lang == "some updated source_lang"
      assert translate.target_lang == "some updated target_lang"
      assert translate.translation == %{}
    end

    test "update_translate/2 with invalid data returns error changeset" do
      translate = translate_fixture()
      assert {:error, %Ecto.Changeset{}} = Translations.update_translate(translate, @invalid_attrs)
      assert translate == Translations.get_translate!(translate.id)
    end

    test "delete_translate/1 deletes the translate" do
      translate = translate_fixture()
      assert {:ok, %Translate{}} = Translations.delete_translate(translate)
      assert_raise Ecto.NoResultsError, fn -> Translations.get_translate!(translate.id) end
    end

    test "change_translate/1 returns a translate changeset" do
      translate = translate_fixture()
      assert %Ecto.Changeset{} = Translations.change_translate(translate)
    end
  end
end
