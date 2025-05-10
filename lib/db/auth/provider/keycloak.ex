defmodule Db.Auth.Provider.Keycloak do
  @moduledoc """
  Defines the authentication with Keycloak and is responsible
  normalizing the client scopes.
  """
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      base_url: Application.get_env(:db, :oauth_base_url),
      authorize_url: "/protocol/openid-connect/auth",
      token_url: "/protocol/openid-connect/token",
      user_url: "/protocol/openid-connect/userinfo",
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
