defmodule GuedesBankWeb.UsersJSON do
  @moduledoc "Users JSON"

  alias GuedesBank.Users.Schema.User

  def user_create(%{user: user}), do: %{data: data(user)}

  def get_user(%{user: user}), do: %{data: data(user)}

  def update_user(%{user: user}), do: %{data: data(user)}

  def delete_user(%{user: user}), do: %{data: data(user)}

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      cep: user.cep
    }
  end
end
