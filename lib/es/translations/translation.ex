defmodule Es.Translations.Translation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "translations" do
    field :source, :string
    field :source_lang, :string
    field :target_lang, :string
    field :translation, :map
    field :quick_translations, {:array, :string}
    field :examples, {:array, :string}

    embeds_many :full_translations, __MODULE__.FullTranslation, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(translate, attrs) do
    translate
    |> cast(attrs, [
      :source,
      :source_lang,
      :target_lang,
      :translation,
      :quick_translations,
      :examples
    ])
    |> validate_required([:source, :source_lang, :target_lang, :translation])
  end
end

defmodule Es.Translations.Translation.FullTranslation do
  use Ecto.Schema
  @derive Jason.Encoder

  @primary_key false
  embedded_schema do
    field :part_of_speech, :string

    embeds_many :items, __MODULE__.Item
  end
end

defmodule Es.Translations.Translation.FullTranslation.Item do
  use Ecto.Schema
  @derive Jason.Encoder

  @primary_key false
  embedded_schema do
    field :word, :string
    field :translations, {:array, :string}
    field :popularity, :integer

    embeds_many :definitions, __MODULE__.Definition
  end
end

defmodule Es.Translations.Translation.FullTranslation.Item.Definition do
  use Ecto.Schema
  @derive Jason.Encoder

  @primary_key false
  embedded_schema do
    field :meaning, :string
    field :example, :string
    field :synonyms, {:array, :string}
  end
end
