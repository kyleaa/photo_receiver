ExUnit.start()

Mix.Task.run("ecto.create", ~w(-r PhotoReceiver.Repo --quiet))
Mix.Task.run("ecto.migrate", ~w(-r PhotoReceiver.Repo --quiet))
Ecto.Adapters.SQL.Sandbox.mode(PhotoReceiver.Repo, :manual)
