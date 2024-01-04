defmodule GuedesBank.Users.Inputs.UpdateUser do
  use Ecto.Schema
  import Ecto.Changeset

  @required ~w(id)a
  @optional ~w(name email cep password)a

  @primary_key false
  embedded_schema do
    field :id, :string
    field :name, :string
    field :email, :string
    field :cep, :string
    field :password, :string
  end

  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cep, is: 8)
  end
end
