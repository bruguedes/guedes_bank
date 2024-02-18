defmodule GuedesBank.Accounts.Schema.Account do
  @moduledoc "Account schema"

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias GuedesBank.Repo
  alias GuedesBank.Users.Schema.User

  @required ~w(balance user_id)a

  schema "accounts" do
    field :account_number, :string
    field :balance, :decimal, default: 0.0
    belongs_to :user, User

    timestamps()
  end

  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, @required)
    |> validate_required(@required)
    |> unique_constraint(:user_id, name: :unique_accounts_user)
    |> check_constraint(:balance, name: :balance_must_be_positive)
    |> generate_account_number()
  end

  defp generate_account_number(%{valid?: true} = changeset) do
    account_number = generate_account_number()

    put_change(changeset, :account_number, account_number)
  end

  defp generate_account_number(changeset), do: changeset

  defp generate_account_number do
    account_number =
      00_001..90_000
      |> Enum.random()
      |> to_string

    query = from a0 in __MODULE__, where: a0.account_number == ^account_number

    if Repo.exists?(query) do
      generate_account_number()
    else
      account_number
    end
  end
end
