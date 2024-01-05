defmodule GuedesBank.ExternalClient.ViaVep do
  @moduledoc "ViaCep client"

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://viacep.com.br/ws/"
  plug Tesla.Middleware.JSON

  @status_errors [{500, :internal_server_error}, {400, :bad_resquest}]
  def call(cep) do
    "#{cep}/json"
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
