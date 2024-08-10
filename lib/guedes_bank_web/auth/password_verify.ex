defmodule GuedesBankWeb.Auth.PasswordVerify do
  @moduledoc """
  Module responsible for verifying the user's password.
  """

  alias GuedesBank.Users
  alias GuedesBank.Users.Schema.User

  @spec call(map()) :: {:ok, :authorized} | {:error, :unauthorized | String.t()}
  def call(%{"user_id" => id, "password" => password}) do
    id
    |> Users.get()
    |> verify_user_password(password)
  end

  defp verify_user_password({:ok, %User{password_hash: password_hash}}, password) do
    case Argon2.verify_pass(password, password_hash) do
      true -> {:ok, :valid_password}
      false -> {:error, :unauthorized}
    end
  end

  defp verify_user_password({:error, _} = error, _password), do: error
end
