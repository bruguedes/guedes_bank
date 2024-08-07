defmodule GuedesBank.Users.Schema.User do
  @moduledoc "User schema"

  use Ecto.Schema
  import Ecto.Changeset
  import GuedesBank.Helpers.Query

  alias GuedesBank.Accounts.Schema.Account

  @required ~w(name password email cep)a

  schema "users" do
    field :name, :string
    field :email, :string
    field :cep, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_one :account, Account

    timestamps()
  end

  def changeset(params), do: do_changeset(%__MODULE__{}, params)

  def changeset(user, params), do: do_changeset(user, params, @required -- [:password])

  def do_changeset(struct, params, fields \\ @required) do
    struct
    |> cast(params, @required)
    |> validate_required(fields)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> validate_length(:cep, is: 8)
    |> add_hash_password()
  end

  defp add_hash_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password_hash: Argon2.hash_pwd_salt(password))
  end

  defp add_hash_password(changeset), do: changeset

  def user_exists?(filters), do: exists?(__MODULE__, filters)
  def get_user(filters), do: get(__MODULE__, filters, "user")
  def get_by_user(filters), do: get_by(__MODULE__, filters, "user")
end
