defmodule ApiServerWeb.User do
  @users [
    %{
      id: 1,
      name: "Bill",
      email: "bill@gmail.com",
      preferences: %{
        likes_emails: false,
        likes_phone_calls: true
      }
    },
    %{
      id: 2,
      name: "Alice",
      email: "alice@gmail.com",
      preferences: %{
        likes_emails: true,
        likes_phone_calls: false
      }
    },
    %{
      id: 3,
      name: "Jill",
      email: "jill@hotmail.com",
      preferences: %{
        likes_emails: true,
        likes_phone_calls: true
      }
    },
    %{
      id: 4,
      name: "Tim",
      email: "tim@gmail.com",
      preferences: %{
        likes_emails: false,
        likes_phone_calls: false
      }
    }
  ]

  @doc "Return all users whose preferences match given query"
  def all(prefs) do
    case match_on_prefs(prefs) do
      [] -> {:error, %{message: "not found", details: %{preferences: prefs}}}
      users -> {:ok, users}
    end
  end

  # Refactoring:
  # case Enum.filter(@users, &match?(^prefs,mask_keys(&1.prefences,request_keys))) do

  defp match_on_prefs(prefs) do
    request_keys = Map.keys(prefs)
    Enum.filter(@users, &match?(^prefs, mask_keys(&1, request_keys)))
  end

  defp mask_keys(user, keys) do
    Map.take(user.preferences, keys)
  end

  # Don't need fall-through since prefs can be empty
  # def all(_) do
  #   {:ok, @users}
  # end

  @doc "Return single user with given id"
  def find(id) do
    case Enum.find(@users, &(&1.id == id)) do
      nil -> {:error, %{message: "not found", details: %{id: id}}}
      user -> {:ok, user}
    end
  end

  # These do not actually persist because user list is just module attribute
  # and is reset for every process run

  @doc "Add a user"
  def add(id, params) do
    case Enum.find(@users, &(&1.id == id)) do
      nil ->
        user = params
        {:ok, user}

      _user ->
        {:error, %{message: "user exists", details: %{id: id}}}
    end
  end

  @doc "Change a user first level params"
  def update(id, params) do
    with {:ok, user} <- find(id) do
      {:ok, Map.merge(user, params)}
    end
  end

  @doc "Change a users preferences"
  def update_preferences(id, params) do
    with {:ok, user} <- find(id) do
      merge_prefs = Map.merge(user.preferences, params)
      user = Map.merge(user, %{preferences: merge_prefs})
      {:ok, user.preferences}
    end
  end
end
