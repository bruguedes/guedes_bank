defmodule GuedesBankWeb.FallbackController do
  use GuedesBankWeb, :controller

  @request_status [
    {:invalid_cep, :bad_request, "invalid CEP"},
    {:user_not_found, :not_found, "User not found"},
    {:account_not_found, :not_found, "Account not found"},
    {:balance_must_be_positive, :unprocessable_entity, "balance must be positive"}
  ]

  def call(conn, {:error, %Ecto.Changeset{valid?: false} = changeset}) do
    render_error(conn, :bad_request, changeset)
  end

  def call(conn, {:error, reason}) do
    {_, status, description} =
      Enum.find(@request_status, fn {key, _, _} -> key == reason end)

    render_error(conn, status, description)
  end

  defp render_error(conn, status, error) do
    conn
    |> put_status(status)
    |> put_view(json: GuedesBankWeb.ErrorJSON)
    |> render(:error, error: error)
  end
end
