defmodule GuedesBankWeb.AccountsController do
  use GuedesBankWeb, :controller

  alias GuedesBank.Accounts
  alias GuedesBank.Accounts.Inputs.CreateAccount
  alias GuedesBank.Accounts.Inputs.TransactionInput
  alias GuedesBank.Helpers.InputValidation

  action_fallback GuedesBankWeb.FallbackController

  def create(conn, params) do
    with {:ok, input} <- InputValidation.validate_and_change(CreateAccount, params),
         {:ok, account} <- Accounts.create_account(input) do
      conn
      |> put_status(:created)
      |> render(:account_create, data: account)
    end
  end

  def transaction(conn, params) do
    with {:ok, params} <- InputValidation.validate_and_change(TransactionInput, params),
         {:ok, transaction} <- Accounts.transaction(params) do
      conn
      |> put_status(:ok)
      |> render(:transaction, data: transaction)
    end
  end
end
