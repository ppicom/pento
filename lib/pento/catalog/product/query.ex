defmodule Pento.Catalog.Product.Query do
  @moduledoc """
  The Product query context.
  """
  import Ecto.Query

  alias Pento.Accounts.User
  alias Pento.Catalog.Product
  alias Pento.Survey.{Rating, Demographic}

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

  @doc """
  Returns the average rating of products in the form of a tuple

  {"product-name", 3.56}
  """
  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings
    |> average_ratings
  end

  defp join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  defp average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, fragment("?::float", avg(r.stars))})
  end
end
