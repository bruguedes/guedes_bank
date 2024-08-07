defmodule GuedesBankWeb.AccountsJSON do
  @moduledoc "Accounts JSON"

  alias GuedesBank.Accounts.Schema.Account

  def account_create(%{data: account}), do: %{data: data(account)}
  def transaction(%{data: transaction}), do: %{data: data(transaction)}

  defp data(%Account{} = account) do
    %{
      id: account.id,
      user_id: account.user_id,
      account_number: account.account_number,
      balance: account.balance
    }
  end

  defp data(transaction) do
    %{
      transaction_type: transaction.transaction_type,
      status: transaction.status,
      to_account: transaction.to_account,
      form_account: transaction.form_account,
      value: transaction.value,
      date: transaction.date
    }
  end
end
