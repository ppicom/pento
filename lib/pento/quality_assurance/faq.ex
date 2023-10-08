defmodule Pento.QualityAssurance.FAQ do
  use Ecto.Schema
  import Ecto.Changeset

  schema "faqs" do
    field :question, :string
    field :answer, :string
    field :votes, :integer

    timestamps()
  end

  @doc false
  def changeset(faq, attrs) do
    faq
    |> cast(attrs, [:question, :answer, :votes])
    |> validate_required([:question, :answer, :votes])
    |> unique_constraint(:question)
  end
end
