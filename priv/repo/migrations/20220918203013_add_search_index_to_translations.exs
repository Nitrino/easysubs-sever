defmodule Es.Repo.Migrations.AddSearchIndexToTranslations do
  use Ecto.Migration

  def change do
    execute(&execute_up/0, &execute_down/0)
  end

  defp execute_up do
    """
    ALTER TABLE translations ADD COLUMN ts tsvector GENERATED ALWAYS AS (to_tsvector('english', source)) STORED;
    CREATE INDEX idx_translations_ts ON translations USING GIN (ts);
    """
  end

  defp execute_down do
    """
    ALTER TABLE translations DROP COLUMN ts;
    CREATE INDEX idx_translations_ts ON translations (ts);
    """
  end
end
