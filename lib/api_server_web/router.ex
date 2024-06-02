defmodule ApiServerWeb.Router do
  use ApiServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
    schema: ApiServerWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: ApiServerWeb.Schema,
    socket: ApiServerWeb.UserSocket,
    interface: :playground

  end
end
