# Remove when upstream Pow can handle LiveView/socket auth
defmodule Db.OnMount do
  @moduledoc """
  Provides `on_mount/4` hooks for LiveView authentication and localization.

  ## Responsibilities

    * Assigns the authenticated user (`@current_user`) to the LiveView socket.
    * Sets the locale (`de` or `en`) based on the user's stored preference.

  @link: https://github.com/pow-auth/pow/issues/706
  """
  use Phoenix.LiveView
  use DbWeb, :verified_routes

  def on_mount(:default, _params, session, socket) do
    socket = mount_session(socket, session)

    if socket.assigns.current_user do
      mound_locale(socket.assigns.current_user.locale)

      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "Session timout")
        |> Phoenix.LiveView.redirect(to: ~p"/session/new")

      {:halt, socket}
    end
  end

  @spec mount_session(
          socket :: Phoenix.LiveView.Socket.t(),
          session :: Phoenix.LiveView.Socket.t()
        ) :: Phoenix.LiveView.Session.t()
  defp mount_session(socket, session) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      {_conn, user} =
        %Plug.Conn{
          private: %{
            plug_session_fetch: :done,
            plug_session: session,
            pow_config: [otp_app: :db]
          },
          owner: self(),
          remote_ip: {0, 0, 0, 0}
        }
        |> Map.put(:secret_key_base, DbWeb.Endpoint.config(:secret_key_base))
        |> Pow.Plug.Session.fetch(otp_app: :db)

      user
    end)
  end

  @spec mound_locale(locale :: String.t()) :: no_return()
  defp mound_locale(locale) do
    Gettext.put_locale(DbWeb.Gettext, locale || "en")
  end
end
