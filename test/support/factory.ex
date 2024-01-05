defmodule GuedesBank.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: GuedesBank.Repo

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
end
