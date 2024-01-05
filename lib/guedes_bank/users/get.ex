defmodule GuedesBank.Users.Get do
  @moduledoc "Get User domain"

  alias GuedesBank.Repo
  alias GuedesBank.Users.Schema.User

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
