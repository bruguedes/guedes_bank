defmodule GuedesBank.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: GuedesBank.Repo

  alias GuedesBank.Accounts.Schema.Account
  alias GuedesBank.Users.Schema.User

  def user_factory do
    name = sequence(:name, &"User #{&1}")
    email = sequence(:email, &"user#{&1}@bruguedes.com")

    %User{
      name: name,
      email: email,
      password_hash: Argon2.hash_pwd_salt("123456"),
      cep: "12345678"
    }
  end

  def account_factory do
    user = insert(:user)

    account_number =
      00_001..90_000
      |> Enum.random()
      |> to_string

    %Account{
      user_id: user.id,
      account_number: account_number,
      balance: 0
    }
  end
end
