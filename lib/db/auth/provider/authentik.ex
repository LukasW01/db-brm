defmodule Db.Auth.Provider.Authentik do
  @moduledoc """
  Defines the authentication with Authentik and is responsible
  normalizing the client scopes.
  """
  use Assent.Strategy.OAuth2.Base

  @impl true
  def default_config(_config) do
    [
      base_url: "#{Application.get_env(:db, :oauth_base_url)}/application/o",
      authorize_url: "/authorize/",
      token_url: "/token/",
      user_url: "/userinfo/",
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
