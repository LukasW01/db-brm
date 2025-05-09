[
  import_deps: [:ecto, :ecto_sql, :phoenix, :let_me],
  subdirectories: ["priv/*/migrations"],
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs:
    Enum.flat_map(
      ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"],
      &Path.wildcard(&1, match_dot: true)
    ) -- Path.wildcard("lib/**/mails/*.ex", match_dot: true)
]
