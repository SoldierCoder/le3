defmodule ApiServerWeb.Types.User do
  use Absinthe.Schema.Notation

  @desc "User preferences for contact"
  object :user_preferences do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
  end

  @desc "User params for creation mutation"
  input_object :user_preference_params do
    field :likes_emails, :boolean
    field :likes_phone_calls, :boolean
  end

  @desc "A user"
  object :user do
    field :id, :id
    field :name, :string
    field :email, :string
    field :preferences, :user_preferences
  end

end
