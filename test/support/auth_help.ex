defmodule GuedesBank.AuthHelper do
  @moduledoc """
  Module responsible for helping with authentication in tests.
  """
  import Plug.Conn

  alias GuedesBankWeb.Auth.Token

  def conn_with_token(conn) do
    user = GuedesBank.Factory.build(:user)
    put_req_header(conn, "authorization", "Bearer #{Token.sign(user.id)}")
  end
end
