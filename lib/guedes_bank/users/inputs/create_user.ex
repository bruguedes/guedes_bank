defmodule GuedesBank.Users.Inputs.CreateUser do
  @moduledoc "Create User input"

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(name password password_confirmation email cep)a

  embedded_schema do
    field :name, :string
    field :email, :string
    field :cep, :string
    field :password, :string
    field :password_confirmation
  end

  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:name, min: 3)
    |> validate_length(:cep, is: 8)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
  end
end
