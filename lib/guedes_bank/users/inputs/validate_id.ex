defmodule GuedesBank.Users.Inputs.ValidateId do
  @moduledoc "Validate ID input"

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :id, :string
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, [:id])
    |> validate_required([:id])
    |> validate_format(:id, ~r/^\d+$/, message: "invalid value in the field id")
  end
end
