ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhotoReceiver.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhotoReceiver.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhotoReceiver.Repo)

