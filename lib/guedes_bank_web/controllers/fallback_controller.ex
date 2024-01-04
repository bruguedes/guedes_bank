defmodule GuedesBankWeb.FallbackController do
  use GuedesBankWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{valid?: false} = changeset}) do
    conn
    |> put_status(:bad_request)
    |> put_view(json: GuedesBankWeb.ErrorJSON)
    |> render(:error, error: changeset)
  end

  def call(conn, {:error, :user_not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: GuedesBankWeb.ErrorJSON)
    |> render(:error, error: "User not found")
  end
end
