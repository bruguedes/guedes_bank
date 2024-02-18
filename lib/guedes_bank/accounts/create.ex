defmodule GuedesBank.Accounts.Create do
  @moduledoc "Create Account domain"

  alias GuedesBank.Accounts.Inputs.CreateAccount
  alias GuedesBank.Accounts.Schema.Account
  alias GuedesBank.Repo
  alias GuedesBank.Users

  @spec call(map()) :: {:ok, map()} | {:error, atom() | Ecto.Changeset.t()}
  def call(%CreateAccount{user_id: user_id} = params) do
    input = Map.from_struct(params)

    with true <- Users.exists?(user_id),
         %{valid?: true} = account_struct <- Account.changeset(input),
         {:ok, _} = result <- Repo.insert(account_struct) do
      result
    else
      {:error, _} = err -> err
      %{valid?: false} = changeset -> {:error, changeset}
      false -> {:error, :user_not_found}
    end
  end
end
