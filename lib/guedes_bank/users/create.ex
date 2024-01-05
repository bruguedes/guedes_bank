defmodule GuedesBank.Users.Create do
  @moduledoc "Create User domain"

  alias GuedesBank.Repo
  alias GuedesBank.Users.Inputs.CreateUser
  alias GuedesBank.Users.Schema.User

  def call(%CreateUser{} = params) do
    params
    |> Map.from_struct()
    |> User.changeset()
    |> Repo.insert()
  end
end
