defmodule GuedesBankWeb.AccountsControllerTest do
  use GuedesBankWeb.ConnCase, async: true

  @base_url "/api/accounts"

  describe "create/2" do
    test "successfully creates an account when data is valid", ctx do
      %{id: user_id} = insert(:user)

      params = %{"user_id" => "#{user_id}", "balance" => 100}

      assert %{
               "data" => %{
                 "user_id" => ^user_id,
                 "account_number" => _,
                 "balance" => "100",
                 "id" => _
               }
             } =
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:created)
    end

    test "returns an error when required params not sent", ctx do
      assert %{"errors" => %{"user_id" => ["can't be blank"], "balance" => ["can't be blank"]}} =
               ctx.conn
               |> post(@base_url, %{})
               |> json_response(:bad_request)
    end

    test "returns an error when balance is invalid", ctx do
      params = %{"user_id" => "#{Enum.random(1..1000)}", "balance" => "invalid"}

      assert %{"errors" => %{"balance" => ["is invalid"]}} =
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:bad_request)
    end

    test "returns an error when user not found", ctx do
      invalid_user = Enum.random(1..1000)

      params = %{"user_id" => "#{invalid_user}", "balance" => 100}

      assert %{"error" => "User not found"} =
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:not_found)
    end
  end
end
