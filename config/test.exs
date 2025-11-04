import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :db, Db.Repo,
  database: Path.expand("../db_test.db", __DIR__),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :db, DbWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Ti8HqxMZz/EkPIn1PTiYQI9CcJxyxTO1dWPGyVuGPCCq5BJLG2GyiScybGOkEZVf",
  server: false

# In test we don't send emails
config :db, Db.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

config :db, Oban, testing: :manual

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# JUnit formatter
config :junit_formatter,
  report_file: "unit.xml",
  report_dir: "test/",
  print_report_file: true,
  prepend_project_name?: true,
  include_filename?: true
