defmodule GuedesBank.Accounts.Transaction do
  @moduledoc "Transaction domain"

  alias Decimal
  alias Ecto.Multi
  alias GuedesBank.Accounts
  alias GuedesBank.Accounts.Schema.Account
  alias GuedesBank.Repo

  def call(%{
        operation_type: :transference,
        to_account: to_account_number,
        form_account: form_account_number,
        value: value
      }) do
    with {:ok, value} <- Decimal.cast(value),
         {:ok, to_account} <- Accounts.get_by(account_number: to_account_number),
         {:ok, form_account} <- Accounts.get_by(account_number: form_account_number),
         {:ok, _} = result <- execute(to_account, form_account, value) do
      result
    else
      :error -> {:error, :invalid_value}
      error -> error
    end
  end

  defp execute(to_account, form_account, value) do
    Multi.new()
    |> Multi.run(:to_account, fn _, _ -> operation(:withdraw, to_account, value) end)
    |> Multi.run(:form_account, fn _, _ -> operation(:deposit, form_account, value) end)
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, build_result(result, value)}
      {:error, _step, reason, _changes} -> {:error, reason}
    end
  end

  defp operation(operation_type, account, value) do
    with {:ok, new_balance} <- balance_available(operation_type, account.balance, value),
         %{valid?: true} = input <- Account.changeset(account, %{balance: new_balance}),
         {:ok, _} <- Repo.update(input) do
      {:ok, account}
    else
      %{valid?: false} = changeset -> {:error, changeset}
      {:error, _} = error -> error
    end
  end

  defp balance_available(:withdraw, balance, value) do
    new_balance = Decimal.sub(balance, value)

    if Decimal.compare(new_balance, Decimal.new(0)) == :lt do
      {:error, :balance_must_be_positive}
    else
      {:ok, new_balance}
    end
  end

  defp balance_available(:deposit, balance, value), do: {:ok, Decimal.add(balance, value)}

  defp build_result(%{to_account: to_account, form_account: form_account}, value) do
    %{
      transaction_type: :transference,
      status: :success,
      to_account: to_account.account_number,
      form_account: form_account.account_number,
      value: value,
      date: to_account.updated_at
    }
  end
end
