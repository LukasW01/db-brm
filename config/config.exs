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
config :db, Db.Mailer,
  adapter: Swoosh.Adapters.Local,
  from: System.get_env("MAILER_FROM")

config :db, Oban,
  engine: Oban.Engines.Lite,
  notifier: Oban.Notifiers.PG,
  queues: [default: 10],
  repo: Db.Repo

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

# Auth
config :db,
  oauth_provider: System.get_env("OAUTH_PROVIDER"),
  oauth_base_url: System.get_env("OAUTH_BASE_URL"),
  oauth_realm: System.get_env("OAUTH_REALM")

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

  "AUTHENTIK" ->
    config :db, :pow_assent,
      providers: [
        Authentik: [
          client_id: System.get_env("OAUTH_CLIENT_ID"),
          client_secret: System.get_env("OAUTH_CLIENT_SECRET"),
          strategy: Db.Auth.Provider.Authentik
        ]
      ]

  nil ->
    nil

  other ->
    raise "Unsupported OAUTH_PROVIDER value: #{inspect(other)}; Expected: 'KEYCLOAK', 'AUTHENTIK'"
end

# Crypto
config :db,
  encryption_key: System.get_env("ENCRYPTION_KEY")

# Pushover
config :db,
  pushover_user: System.get_env("PUSHOVER_USER"),
  pushover_token: System.get_env("PUSHOVER_TOKEN")

# Discord
config :db,
  webhook_url: System.get_env("DISCORD_WEBHOOK")

# WebDAV
config :db,
  webdav_url: System.get_env("WEBDAV_URL"),
  webdav_user: System.get_env("WEBDAV_USER"),
  webdav_pw: System.get_env("WEBDAV_PW")

# S3
config :ex_aws,
  debug_requests: true,
  json_codec: Jason,
  access_key_id: System.get_env("S3_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("S3_SECRET_ACCESS_KEY")

config :ex_aws, :s3,
  scheme: "https://",
  host: System.get_env("S3_HOST"),
  region: System.get_env("S3_REGION")

# Sentry
config :sentry,
  dsn:
    "https://1a3510ea37dc4ae4992ab25b0fb0ed7e@sentry.wigger.one/3",
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_paths: [File.cwd!()]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
