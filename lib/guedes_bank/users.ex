defmodule GuedesBank.Users do
  @moduledoc "Users domain"

  alias GuedesBank.Users.Create
  alias GuedesBank.Users.Delete
  alias GuedesBank.Users.Schema.User
  alias GuedesBank.Users.Update

  defdelegate create_user(params), to: Create, as: :call
  defdelegate update_user(params), to: Update, as: :call
  defdelegate delete_user(params), to: Delete, as: :call
  defdelegate get(id), to: User, as: :get_user
  defdelegate get_by(filter), to: User, as: :get_by_user
  defdelegate exists?(filters), to: User, as: :user_exists?
end
