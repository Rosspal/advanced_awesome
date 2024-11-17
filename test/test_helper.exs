ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(AdvancedAwesome.Repo, :manual)
Mox.defmock(HttpAdapterMock, for: HTTPoison.Base)
