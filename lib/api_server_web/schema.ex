defmodule ApiServerWeb.Schema do

  use Absinthe.Schema

  import_types ApiServerWeb.Types.User
  import_types ApiServerWeb.Schema.User

  query do
    import_fields :user_queries
  end

  mutation do
    import_fields :user_mutations
  end

  subscription do
    import_fields :user_subscriptions
  end

end
