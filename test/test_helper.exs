ExUnit.configure(formatters: [JUnitFormatter])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Db.Repo, :manual)
