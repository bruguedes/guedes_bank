{:ok, _} = Application.ensure_all_started(:ex_machina)

Mox.defmock(GuedesBank.ExternalClient.ViaCepMock, for: GuedesBank.ExternalClient.ViaCepBehaviour)
Application.put_env(:guedes_bank, :via_cep, GuedesBank.ExternalClient.ViaCepMock)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(GuedesBank.Repo, :manual)
