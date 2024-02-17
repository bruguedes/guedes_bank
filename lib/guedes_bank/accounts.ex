defmodule GuedesBank.Accounts do
  @moduledoc "Accounts domain"

  alias GuedesBank.Accounts.Create

  defdelegate create_account(params), to: Create, as: :call
end
