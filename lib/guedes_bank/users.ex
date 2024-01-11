defmodule GuedesBank.Users do
  @moduledoc "Users domain"

  alias GuedesBank.Users.Create
  alias GuedesBank.Users.Delete
  alias GuedesBank.Users.Get
  alias GuedesBank.Users.Update

  defdelegate create_user(params), to: Create, as: :call
  defdelegate get_user(params), to: Get, as: :call
  defdelegate update_user(params), to: Update, as: :call
  defdelegate delete_user(params), to: Delete, as: :call
end
