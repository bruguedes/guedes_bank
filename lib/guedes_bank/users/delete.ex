defmodule GuedesBank.Users.Delete do
  @moduledoc " Delete User domain"

  alias GuedesBank.Repo
  alias GuedesBank.Users

  @spec call(binary()) :: {:ok, map()} | {:error, atom()}
  def call(id) when is_binary(id) do
    id
    |> Users.get_user()
    |> case do
      {:ok, user} -> Repo.delete(user)
      {:error, _} -> {:error, :user_not_found}
    end
  end
end
