defmodule Es.Repo.Migrations.AddGoogleTranslationFields do
  use Ecto.Migration

  def change do
    alter table(:translations) do
      add :quick_translations, {:array, :string}, default: []
      add :full_translations, {:array, :map}, default: []
      add :examples, {:array, :text}, default: []
    end
  end
end
