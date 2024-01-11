defmodule GuedesBank.ExternalClient.ViaCepTest do
  use ExUnit.Case, async: true

  alias GuedesBank.ExternalClient.ViaCep

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "success, when the cep number is valid", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(200, ~s({"cep": "69905-080"}))
      end)

      url = endpoint_url(bypass.port)

      assert {:ok, %{"cep" => "69905-080"}} == ViaCep.call(url, "69905080")
    end

    # Teste de falha quando o número do CEP é inválido.
    test "failure, when the cep number is invalid", %{bypass: bypass} do
      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.resp(400, ~s({"error": "bad_request"}))
      end)

      url = endpoint_url(bypass.port)

      assert {:error, :bad_request} == ViaCep.call(url, "invalid_cep")
    end

    # Teste de falha quando o serviço ViaCep está indisponível.
    test "failure, when ViaCep service is unavailable", %{bypass: bypass} do
      Bypass.down(bypass)
      url = endpoint_url(bypass.port)

      assert {:error, :internal_server_error} == ViaCep.call(url, "69905080")

      Bypass.up(bypass)
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"
end
