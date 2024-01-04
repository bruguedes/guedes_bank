defmodule GuedesBank.Users.Update do
  alias GuedesBank.Repo
  alias GuedesBank.Users
  alias GuedesBank.Users.Schema.User

  def call(%{id: id} = params) do
    id
    |> Users.get_user()
    |> case do
      {:ok, user} -> update_user(user, params)
      {:error, _} -> {:error, :user_not_found}
    end
  end

  defp update_user(user, params) do
    params =
      params
      |> Map.from_struct()
      |> Map.reject(fn {_, v} -> is_nil(v) end)

    user
    |> User.changeset(params)
    |> Repo.update()
  end
end
