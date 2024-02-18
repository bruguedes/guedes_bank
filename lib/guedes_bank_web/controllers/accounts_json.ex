defmodule GuedesBankWeb.AccountsJSON do
  @moduledoc "Accounts JSON"

  alias GuedesBank.Accounts.Schema.Account

  def account_create(%{account: account}), do: %{data: data(account)}

  def get_user(%{user: user}), do: %{data: data(user)}

  defp data(%Account{} = account) do
    %{
      id: account.id,
      user_id: account.user_id,
      account_number: account.account_number,
      balance: account.balance
    }
  end
end
