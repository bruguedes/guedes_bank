defmodule GuedesBank.Accounts do
  @moduledoc "Accounts domain"

  alias GuedesBank.Accounts.Create
  alias GuedesBank.Accounts.Schema.Account

  defdelegate create_account(params), to: Create, as: :call
  defdelegate get(id), to: Account, as: :get_account
  defdelegate get_by(filter), to: Account, as: :get_by_account
  defdelegate exists?(filters), to: Account, as: :account_exists?
end
