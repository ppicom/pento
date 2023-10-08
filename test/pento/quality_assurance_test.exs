defmodule Pento.QualityAssuranceTest do
  use Pento.DataCase

  alias Pento.QualityAssurance

  describe "faqs" do
    alias Pento.QualityAssurance.FAQ

    import Pento.QualityAssuranceFixtures

    @invalid_attrs %{question: nil, answer: nil, votes: nil}

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert QualityAssurance.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert QualityAssurance.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      valid_attrs = %{question: "some question", answer: "some answer", votes: 42}

      assert {:ok, %FAQ{} = faq} = QualityAssurance.create_faq(valid_attrs)
      assert faq.question == "some question"
      assert faq.answer == "some answer"
      assert faq.votes == 42
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = QualityAssurance.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      update_attrs = %{question: "some updated question", answer: "some updated answer", votes: 43}

      assert {:ok, %FAQ{} = faq} = QualityAssurance.update_faq(faq, update_attrs)
      assert faq.question == "some updated question"
      assert faq.answer == "some updated answer"
      assert faq.votes == 43
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = QualityAssurance.update_faq(faq, @invalid_attrs)
      assert faq == QualityAssurance.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %FAQ{}} = QualityAssurance.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> QualityAssurance.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = QualityAssurance.change_faq(faq)
    end
  end
end
