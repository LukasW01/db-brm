defmodule DbWeb.Pow.SessionHTML do
  use DbWeb, :html

  case Application.get_env(:db, :oauth_provider) do
    provider when not is_nil(provider) and provider in ["KEYCLOAK", "APPLE", "GOOGLE"] ->
      embed_templates "session_html/oauth/*"

    _ ->
      embed_templates "session_html/auth/*"
  end
end
