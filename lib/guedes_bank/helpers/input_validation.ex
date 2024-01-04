defmodule GuedesBank.Helpers.InputValidation do
  @doc "  Validate and change input"

  alias Ecto.Changeset

  def validate_and_change(shema, params) do
    case shema.changeset(params) do
      %{valid?: true} = changeset -> {:ok, Changeset.apply_changes(changeset)}
      %{valid?: false} = changeset -> {:error, changeset}
    end
  end
end
