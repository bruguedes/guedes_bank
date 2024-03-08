defmodule GuedesBank.Accounts.Schema.Account do
  @moduledoc "Account schema"

  use Ecto.Schema
  import Ecto.Changeset
  import GuedesBank.Helpers.Query

  alias GuedesBank.Users.Schema.User

  @required ~w(balance user_id)a

  schema "accounts" do
    field :account_number, :string
    field :balance, :decimal, default: 0.0
    belongs_to :user, User

    timestamps()
  end

  def changeset_create(params) do
    %__MODULE__{}
    |> changeset(params)
    |> generate_account_number()
  end

  def changeset(account \\ %__MODULE__{}, params) do
    account
    |> cast(params, @required)
    |> validate_required(@required)
    |> unique_constraint(:user_id, name: :unique_accounts_user)
    |> check_constraint(:balance, name: :balance_must_be_positive)
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

    if account_exists?(account_number: account_number) do
      generate_account_number()
    else
      account_number
    end
  end

  def account_exists?(filters), do: exists?(__MODULE__, filters)
  def get_account(filters), do: get(__MODULE__, filters, "account")
  def get_by_account(filters), do: get_by(__MODULE__, filters, "account")
end
