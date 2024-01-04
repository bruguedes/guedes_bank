defmodule GuedesBank.Repo do
  use Ecto.Repo,
    otp_app: :guedes_bank,
    adapter: Ecto.Adapters.Postgres
end
