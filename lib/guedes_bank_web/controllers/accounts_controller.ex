defmodule GuedesBankWeb.AccountsController do
  use GuedesBankWeb, :controller

  alias GuedesBank.Accounts
  alias GuedesBank.Accounts.Inputs.CreateAccount
  alias GuedesBank.Helpers.InputValidation

  action_fallback GuedesBankWeb.FallbackController

  def create(conn, params) do
    with {:ok, input} <- InputValidation.validate_and_change(CreateAccount, params),
         {:ok, account} <- Accounts.create_account(input) do
      conn
      |> put_status(:created)
      |> render(:account_create, account: account)
    end
  end
end
