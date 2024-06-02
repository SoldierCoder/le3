defmodule ApiServerWeb.Schema.User do
  use Absinthe.Schema.Notation

  alias ApiServerWeb.Resolvers


  @desc "Get one or more users"
  object :user_queries do
    @desc "Find a user by id"
    field :user, :user do
      arg :id, non_null(:id)

      resolve &Resolvers.User.find/2
    end

    @desc "Find one or more user(s) by matching preferences"
    field :users, list_of(:user) do
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean

      resolve &Resolvers.User.all/2
    end
  end

  @desc "Create/change users"
  object :user_mutations do
    @desc "Create new user"
    field :create_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      arg :preferences, :user_preference_params

      resolve &Resolvers.User.create/2
      end

    @desc "Change user's params"
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      # arg :preferences, :user_preference_params

      resolve &Resolvers.User.update/2
    end

    @desc "Change a user's preferences"
    field :update_user_preferences, :user_preferences do
      arg :user_id, non_null(:id)
      arg :likes_emails, :boolean
      arg :likes_phone_calls, :boolean

      resolve &Resolvers.User.update_preferences/2
      # For debugging subscriptions to see what was being done where
      # resolve fn params, cntx ->
      #    IO.inspect(mutation_resolver: params)
      #    Resolvers.User.update_preferences(params, cntx)
      #  end
    end

  end

  @desc "Open a subscription"
  object :user_subscriptions do
    @desc "A new user was created"
    field :created_user, :user do
      config fn _, _ ->
        {:ok, topic: "*"}
      end

      trigger :create_user, topic: fn _ ->
        "*"
      end
    end

    @desc "User preferences were updated"
    field :updated_user_preferences, :user_preferences do
      arg :user_id, non_null(:id)

       # This happens when subscription is created
       config fn args, _ ->
          {:ok, topic: args.user_id}
       end

       # This hooks to action that will cause results to be returned
       # it gets run even if there is no active subscription
      trigger :update_user_preferences, topic: fn args ->
         args.user_id
       end

      # This was for debugging.
      # This resolver is run for the subscription to return the results to
      # the subscription and the resolver in the mutation is run for the mutate.
      # Without this, the resolver from the mutation is returned for the subscription.
      # Since this executes after the mutation, it would be
      # just as feasible to look up the user and report the results
      # resolve fn params, cntx ->
      #   IO.inspect(subscription_resolver: params)
      #   Resolvers.User.update_preferences(params, cntx)
      # end
    end

  end
end
