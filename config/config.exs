# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
require Logger

config :db,
  ecto_repos: [Db.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :db, DbWeb.Endpoint,
  url: [
    host: System.get_env("HOSTNAME", "localhost"),
    port: System.get_env("PORT", "4000"),
    scheme: System.get_env("SCHEME", "http")
  ],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DbWeb.ErrorHTML, json: DbWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Db.PubSub,
  live_view: [signing_salt: "4cPZqJyL"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :db, Db.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  db: [
    args:
      ~w(js/app.ts --bundle --target=es2022 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.1.4",
  db: [
    args: ~w(
      --input=css/tailwind.css
      --output=../priv/static/assets/tailwind.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# dart_sass
config :dart_sass,
  version: "1.77.8",
  db: [
    args: ~w(css/app.scss ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :db, DbWeb.Gettext, locales: ~w(de en), default_locale: "de"

config :db, :pow,
  web_mailer_module: DbWeb,
  web_module: DbWeb,
  user: Db.Users.User,
  repo: Db.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: Db.Mailer

# PowAssent (OAuth2 provider)
case System.get_env("OAUTH_PROVIDER") do
  "KEYCLOAK" ->
    config :db, :pow_assent,
      providers: [
        Keycloak: [
          client_id: System.get_env("OAUTH_CLIENT_ID"),
          client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
          strategy: Db.Auth.Provider.Keycloak
        ]
      ]

  "APPLE" ->
    config :db, :pow_assent,
      providers: [
        Apple: [
          client_id: System.get_env("OAUTH_CLIENT_ID"),
          client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
          strategy: Assent.Strategy.Apple
        ]
      ]

  "GOOGLE" ->
    config :db, :pow_assent,
      providers: [
        Google: [
          client_id: System.get_env("OAUTH_CLIENT_ID"),
          client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
          strategy: Assent.Strategy.Google
        ]
      ]

  _ ->
    Logger.info(
      "OAUTH_PROVIDER not configured. Supported providers: 'KEYCLOAK', 'APPLE', 'GOOGLE'"
    )
end

# S3
config :db,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  bucket: System.get_env("S3_BUCKET"),
  region: System.get_env("AWS_REGION"),
  url: System.get_env("S3_URL"),
  host: System.get_env("S3_ALIAS_HOST")

# Sentry
config :sentry,
  dsn:
    "https://eecbfeb25e4ff24ad0d36343704359da@o4506923162533888.ingest.us.sentry.io/4509221108908032",
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
