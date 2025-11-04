defmodule Db.Config do
  @moduledoc """
  Centralized runtime configuration and environment validation.

  Each configuration value is automatically populated from either:

    * **Operating system environment variables** (e.g., `DATABASE_PATH`, `SECRET_KEY_BASE`), or  
    * **Application environment values** defined in `config/*.exs`.
  """
  use Skogsra

  alias Db.Config.Type

  # DB
  app_env(:db_path, :db, [Db.Repo, :path],
    os_env: "DATABASE_PATH",
    type: :binary
  )

  # App
  app_env(:secret_key_base, :db, :secret_key_base,
    os_env: "SECRET_KEY_BASE",
    type: :binary
  )

  app_env(:hostname, :db, [DbWeb.Endpoint, :hostname],
    os_env: "HOSTNAME",
    default: "example.com",
    type: :binary
  )

  app_env(:scheme, :db, [DbWeb.Endpoint, :scheme],
    os_env: "SCHEME",
    default: "https",
    type: :binary
  )

  app_env(:port, :db, [DbWeb.Endpoint, :port],
    os_env: "PORT",
    default: "443",
    type: :integer
  )

  # OAuth
  app_env(:oauth_provider, :db, :oauth_provider,
    os_env: "OAUTH_PROVIDER",
    type: :binary
  )

  app_env(:oauth_base_url, :db, :oauth_base_url,
    os_env: "OAUTH_BASE_URL",
    type: Type.Url
  )

  app_env(:oauth_realm, :db, :oauth_realm,
    os_env: "OAUTH_REALM",
    type: :binary
  )

  app_env(:oauth_client_id, :pow_assent, :client_id,
    os_env: "OAUTH_CLIENT_ID",
    type: :binary
  )

  app_env(:oauth_client_secret, :pow_assent, :client_secret,
    os_env: "OAUTH_CLIENT_SECRET",
    type: :binary
  )

  # Pushover
  app_env(:pushover_user, :db, :user,
    os_env: "PUSHOVER_USER",
    type: :binary
  )

  app_env(:pushover_token, :db, :token,
    os_env: "PUSHOVER_TOKEN",
    type: :binary
  )

  # Discord
  app_env(:webhook_url, :db, :webhook_url,
    os_env: "DISCORD_WEBHOOK",
    type: Type.Discord
  )

  # S3
  app_env(:s3_access_key_id, :ex_aws, :s3_access_key_id,
    os_env: "S3_ACCESS_KEY_ID",
    type: :binary
  )

  app_env(:s3_secret_access_key, :ex_aws, :s3_secret_access_key,
    os_env: "S3_SECRET_ACCESS_KEY",
    type: :binary
  )

  app_env(:s3_host, :ex_aws, :s3_host,
    os_env: "S3_HOST",
    type: Type.BaseUrl
  )

  app_env(:s3_region, :ex_aws, :s3_region,
    os_env: "S3_REGION",
    type: :binary
  )

  # WebDAV
  app_env(:webdav_url, :db, :webdav_url,
    os_env: "WEBDAV_URL",
    type: Type.Url
  )

  app_env(:webdav_user, :db, :webdav_user,
    os_env: "WEBDAV_USER",
    type: :binary
  )

  app_env(:webdav_pw, :db, :webdav_pw,
    os_env: "WEBDAV_PW",
    type: :binary
  )

  # Mailgun
  app_env(:mailgun_api_key, :db, [Db.Mailer, :api_key],
    os_env: "MAILGUN_API_KEY",
    type: :binary
  )

  app_env(:mailgun_domain, :db, [Db.Mailer, :domain],
    os_env: "MAILGUN_DOMAIN",
    type: Type.BaseUrl
  )

  app_env(:mailgun_base_url, :db, [Db.Mailer, :base_url],
    default: "https://api.mailgun.net/v3",
    os_env: "MAILGUN_BASE_URL",
    type: Type.Mailgun
  )

  # SMTP
  app_env(:mailer_relay, :db, [Db.Mailer, :relay],
    os_env: "MAILER_HOST",
    type: Type.BaseUrl
  )

  app_env(:mailer_username, :db, [Db.Mailer, :username],
    os_env: "MAILER_USER",
    type: Type.Mail
  )

  app_env(:mailer_password, :db, [Db.Mailer, :password],
    os_env: "MAILER_PW",
    type: :binary
  )

  app_env(:mailer_port, :db, [Db.Mailer, :port],
    default: 456,
    os_env: "MAILER_PORT",
    type: :integer
  )

  app_env(:mailer_from, :db, [Db.Mailer, :from],
    os_env: "MAILER_FROM",
    type: Type.Mail
  )

  # Encryption
  app_env(:encryption_key, :db, :encryption_key,
    os_env: "ENCRYPTION_KEY",
    type: Type.Key
  )
end
