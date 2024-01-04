defmodule GuedesBank.Users.Create do
  alias GuedesBank.Repo
  alias GuedesBank.Users.Schema.User
  alias GuedesBank.Users.Inputs.CreateUser

  def call(%CreateUser{} = params) do
    params
    |> Map.from_struct()
    |> User.changeset()
    |> Repo.insert()
  end
end
