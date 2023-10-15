defmodule Pento.Catalog.Product.Query do
  @moduledoc """
  The Product query context.
  """
  import Ecto.Query

  alias Pento.Catalog.Product
  alias Pento.Survey.Rating

  def base, do: Product

  @doc """
  Returns a query for products rated by a given user.

  """
  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  defp preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end
end
