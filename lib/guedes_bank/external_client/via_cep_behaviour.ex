defmodule GuedesBank.ExternalClient.ViaCepBehaviour do
  @moduledoc """
  Behaviour for the ViaCep client in the GuedesBank application.
  This behaviour defines a single callback, `call/1`, which is expected to be implemented by any module using this behaviour.
  The `call/1` function is expected to take a string argument and returns a tuple.
  """

  @callback call(String.t()) :: {:ok, map()} | {:error, :aton}
end
