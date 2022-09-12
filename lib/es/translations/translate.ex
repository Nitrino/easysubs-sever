defmodule Es.Translations.Translate do
  use Ecto.Schema
  import Ecto.Changeset

  schema "translations" do
    field :source, :string
    field :source_lang, :string
    field :target_lang, :string
    field :translation, :map

    timestamps()
  end

  @doc false
  def changeset(translate, attrs) do
    translate
    |> cast(attrs, [:source, :source_lang, :target_lang, :translation])
    |> validate_required([:source, :source_lang, :target_lang, :translation])
  end
end
