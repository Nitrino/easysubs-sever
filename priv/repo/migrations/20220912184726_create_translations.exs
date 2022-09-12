defmodule Es.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations) do
      add :source, :string, null: false
      add :source_lang, :string, null: false
      add :target_lang, :string, null: false
      add :translation, :map, null: false

      timestamps()
    end
  end
end
