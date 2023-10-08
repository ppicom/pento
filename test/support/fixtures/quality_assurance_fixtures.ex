defmodule Pento.QualityAssuranceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pento.QualityAssurance` context.
  """

  @doc """
  Generate a unique faq question.
  """
  def unique_faq_question, do: "some question#{System.unique_integer([:positive])}"

  @doc """
  Generate a faq.
  """
  def faq_fixture(attrs \\ %{}) do
    {:ok, faq} =
      attrs
      |> Enum.into(%{
        question: unique_faq_question(),
        answer: "some answer",
        votes: 42
      })
      |> Pento.QualityAssurance.create_faq()

    faq
  end
end
