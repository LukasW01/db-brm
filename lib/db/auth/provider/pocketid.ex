defmodule Db.Auth.Provider.PocketID do
  @moduledoc """
  Implements authentication via Pocket ID using OAuth2 and normalizes
  the returned user information for internal use.
  """
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      base_url: "#{Application.get_env(:db, :oauth_base_url)}",
      authorize_url: "/authorize",
      token_url: "/api/oidc/token",
      user_url: "/api/oidc/userinfo",
      authorization_params: [scope: "email openid profile"],
      auth_method: :client_secret_post
    ]
  end

  @impl true
  def normalize(_config, user) do
    {:ok,
     %{
       "sub" => user["sub"],
       "name" => user["name"],
       "email" => user["email"],
       "locale" => user["locale"],
       "role" => List.first(user["group"] || [])
     }}
  end
end
