defmodule GuedesBank.Accounts.Inputs.TransactionInput do
  @moduledoc "Transaction Input"

  use Ecto.Schema
  import Ecto.Changeset
  @regex_format_number ~r/^\d+$/
  @operation_type ~W(deposit withdraw transference)a
  @required ~w(operation_type form_account to_account value)a

  embedded_schema do
    field :operation_type, Ecto.Enum, values: @operation_type
    field :form_account, :string
    field :to_account, :string
    field :value, :string
  end

  def changeset(struct \\ %__MODULE__{}, params) do
    struct
    |> cast(params, @required)
    |> validate_required(@required)
    |> validate_format(:form_account, @regex_format_number, message: "invalid form_account")
    |> validate_format(:to_account, @regex_format_number, message: "invalid to_account")
    |> validate_format(:value, @regex_format_number, message: "invalid value")
  end
end
