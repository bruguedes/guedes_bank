defmodule GuedesBankWeb.UsersController do
  use GuedesBankWeb, :controller

  alias GuedesBank.Helpers.InputValidation
  alias GuedesBank.Users
  alias GuedesBank.Users.Inputs.CreateUser
  alias GuedesBank.Users.Inputs.UpdateUser
  alias GuedesBank.Users.Inputs.ValidateId
  alias GuedesBankWeb.Auth.PasswordVerify
  alias GuedesBankWeb.Auth.Token

  action_fallback GuedesBankWeb.FallbackController

  def create(conn, params) do
    with {:ok, input} <- InputValidation.validate_and_change(CreateUser, params),
         {:ok, user} <- Users.create_user(input) do
      conn
      |> put_status(:created)
      |> render(:user_create, user: user)
    end
  end

  def show(conn, params) do
    with {:ok, %{id: id}} <- InputValidation.validate_and_change(ValidateId, params),
         {:ok, user} <- Users.get(id) do
      conn
      |> put_status(:ok)
      |> render(:get_user, user: user)
    end
  end

  def update(conn, params) do
    with {:ok, params} <- InputValidation.validate_and_change(UpdateUser, params),
         {:ok, user} <- Users.update_user(params) do
      conn
      |> put_status(:ok)
      |> render(:update_user, user: user)
    end
  end

  def delete(conn, params) do
    with {:ok, %{id: id}} <- InputValidation.validate_and_change(ValidateId, params),
         {:ok, user} <- Users.delete_user(id) do
      conn
      |> put_status(:ok)
      |> render(:delete_user, user: user)
    end
  end

  def authenticate(conn, %{"user_id" => _, "password" => _} = params) do
    with {:ok, :valid_password} <- PasswordVerify.call(params),
         token <- Token.sign(params["user_id"]) do
      conn
      |> put_status(:ok)
      |> render(:token, %{token: token})
    end
  end

  def authenticate(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> render(:error, %{error: "invalid parameters"})
  end
end
