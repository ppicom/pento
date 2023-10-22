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

  @doc """
  Joins the users that have rated this product.
  """
  def join_users(query \\ base()) do
    query
    |> join(:left, [p, r], u in User, on: r.user_id == u.id)
  end

  @doc """
  Joins the demographics of each user that rated this product.
  Expects the user to be already joined in the query.

  """
  def join_demographics(query \\ base()) do
    query
    |> join(:left, [p, r, u, d], d in Demographic, on: d.user_id == u.id)
  end

  @doc """
  Allows to filter products by age group:
  "all", "18 and under", "18 to 25", "25 to 35" and "35 and up"

  """
  def filter_by_age_group(query \\ base(), filter) do
    query
    |> apply_age_group_filter(filter)
  end

  defp apply_age_group_filter(query, "18 and under") do
    birth_year = DateTime.utc_now().year - 18

    query
    |> where([p, r, u, d], d.year_of_birth >= ^birth_year)
  end

  defp apply_age_group_filter(query, "18 to 25") do
    birth_year_max = DateTime.utc_now().year - 18
    birth_year_min = DateTime.utc_now().year - 25

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "25 to 35") do
    birth_year_max = DateTime.utc_now().year - 25
    birth_year_min = DateTime.utc_now().year - 35

    query
    |> where(
      [p, r, u, d],
      d.year_of_birth >= ^birth_year_min and d.year_of_birth <= ^birth_year_max
    )
  end

  defp apply_age_group_filter(query, "35 and up") do
    birth_year = DateTime.utc_now().year - 35

    query
    |> where([p, r, u, d], d.year_of_birth <= ^birth_year)
  end

  defp apply_age_group_filter(query, _filter) do
    query
  end

  @doc """
  Allows to filter ratings by the gender of the user.

  """
  def filter_by_gender(query \\ base(), gender_filter) do
    query
    |> apply_gender_filter(gender_filter)
  end

  defp apply_gender_filter(query, gender)
       when gender in ["male", "female", "other", "prefer not to say"] do
    query
    |> where([p, r, u, d], d.gender == ^gender)
  end

  defp apply_gender_filter(query, _gender) do
    query
  end

  def with_zero_ratings(query \\ base()) do
    query
    |> select([p], {p.name, 0})
  end
end
