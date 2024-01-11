defmodule GuedesBank.ExternalClient.ViaCep do
  @moduledoc "ViaCep client"

  use Tesla
  alias GuedesBank.ExternalClient.ViaCepBehaviour

  plug Tesla.Middleware.JSON

  @defautl_url "https://viacep.com.br/ws"
  @behaviour ViaCepBehaviour

  @impl true
  def call(url \\ @defautl_url, cep) do
    "#{url}/#{cep}/json"
    |> get()
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: %{"erro" => true}}}) do
    {:error, :not_found}
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: 400}}) do
    {:error, :bad_request}
  end

  defp handle_response({:error, _reason}) do
    {:error, :internal_server_error}
  end
end
