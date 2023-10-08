defmodule Pento.Repo.Migrations.CreateFaqs do
  use Ecto.Migration

  def change do
    create table(:faqs) do
      add :question, :string
      add :answer, :string
      add :votes, :integer

      timestamps()
    end

    create unique_index(:faqs, [:question])
  end
end
