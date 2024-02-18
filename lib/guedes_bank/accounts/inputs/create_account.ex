defmodule GuedesBank.Accounts.Inputs.CreateAccount do
  @moduledoc "Create Account input"

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(balance user_id)a

  embedded_schema do
    field :balance, :decimal
    field :user_id, :id
  end

  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, @required)
    |> validate_required(@required)
  end
end
