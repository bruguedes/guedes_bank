defmodule GuedesBank.Users.Delete do
  alias GuedesBank.Repo
  alias GuedesBank.Users

  def call(id) when is_binary(id) do
    id
    |> Users.get_user()
    |> case do
      {:ok, user} -> Repo.delete(user)
      {:error, _} -> {:error, :user_not_found}
    end
  end
end
