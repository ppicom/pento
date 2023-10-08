defmodule Pento.Promo do
  @moduledoc """
  The Promo context.
  """
  alias Pento.Promo.Recipient

  @doc """
  Changes the recipient of a Promo.
  """
  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  @doc """
  Emails the promo to the recipient.
  """
  def send_promo(_recipient, _attrs) do
    # TODO send email to promo recipient
    {:ok, %Recipient{}}
  end
end
