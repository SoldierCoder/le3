defmodule ApiServerWeb.Resolvers.User do
  use Absinthe.Schema.Notation

  alias ApiServerWeb.User

  @doc "retrun all users that match"
  def all(params, _), do: User.all(params)

  @doc "return one user that has id"
  def find(%{id: id}, _) do
    id = String.to_integer(id)
    User.find(id)
  end

  @doc "make an new user or return error"
  def create(%{id: id} = params, _) do
    id = String.to_integer(id)
    User.add(id, params)
  end

  @doc "update existing user or return error"
  def update(%{id: id} = params, _) do
    id = String.to_integer(id)
    User.update(id, Map.delete(params, :id))
  end

  @doc "update preferences for given user"
  def update_preferences(%{user_id: id} = params, _ ) do
    id = String.to_integer(id)
    # Leave :user_id in args map so trigger can pull it out as topic
    # User.update_preferences(id, Map.delete(params, :user_id))
    User.update_preferences(id, params)
  end

end
