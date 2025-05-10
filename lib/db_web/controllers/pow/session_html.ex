defmodule DbWeb.Pow.SessionHTML do
  use DbWeb, :html

  case Application.compile_env(:db, :oauth_provider) do
    provider
    when not is_nil(provider) and provider in ["KEYCLOAK", "AUTHENTIK", "APPLE", "GOOGLE"] ->
      embed_templates "session_html/oauth/*"

    _ ->
      embed_templates "session_html/auth/*"
  end
end
