defmodule DbWeb.Pow.SessionHTML do
  use DbWeb, :html

  case System.get_env("OAUTH_PROVIDER") do
    provider when provider in ["KEYCLOAK", "APPLE", "GOOGLE"] ->
      embed_templates "session_html/oauth/*"

    provider when provider not in ["KEYCLOAK", "APPLE", "GOOGLE"] ->
      embed_templates "session_html/auth/*"
  end
end
