defmodule DbWeb.Router do
  use DbWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DbWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :skip_csrf_protection do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  scope "/" do
    pipe_through :skip_csrf_protection

    pow_assent_authorization_post_callback_routes()
  end

  scope "/" do
    pipe_through :browser

    case Application.compile_env(:db, :oauth_provider) do
      provider
      when not is_nil(provider) and provider in ["KEYCLOAK", "AUTHENTIK", "APPLE", "GOOGLE"] ->
        pow_session_routes()
        pow_assent_routes()

      _ ->
        pow_routes()
    end

    pow_extension_routes()
  end

  scope "/", DbWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
  end

  scope "/", DbWeb do
    pipe_through :browser
  end

  # Other scopes may use custom stacks.
  # scope "/api", DbWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:db, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DbWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
