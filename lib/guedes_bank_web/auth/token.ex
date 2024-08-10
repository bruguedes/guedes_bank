defmodule GuedesBankWeb.Auth.Token do
  @moduledoc """
  Module responsible for generating and verifying tokens.
  """
  alias Phoenix.Token

  @sign_salt "guedes_bank_api"

  @spec sign(String.t()) :: String.t()
  def sign(user_id) do
    Token.sign(GuedesBankWeb.Endpoint, @sign_salt, %{user_id: user_id})
  end

  @spec verify(String.t()) :: {:ok, map()} | {:error, any()}
  def verify(token), do: Token.verify(GuedesBankWeb.Endpoint, @sign_salt, token, max_age: 900)
end
