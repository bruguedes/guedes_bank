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

    test "returns an error when balance is less than 0", ctx do
      %{id: user_id} = insert(:user)
      params = %{"user_id" => "#{user_id}", "balance" => "-10"}

      assert %{"errors" => %{"balance" => ["is invalid"]}} =
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:bad_request)
    end

    test "returns an error when user_id is nil", ctx do
      params = %{"user_id" => nil, "balance" => 100}

      assert %{"errors" => %{"user_id" => ["can't be blank"]}} ==
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:bad_request)
    end

    test "returns an error when user_id or balance is string empty", ctx do
      params = %{"user_id" => "", "balance" => ""}

      assert %{"errors" => %{"balance" => ["can't be blank"], "user_id" => ["can't be blank"]}} ==
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:bad_request)
    end

    test "returns an error when balance is nil", ctx do
      params = %{"user_id" => "#{Enum.random(1..1000)}", "balance" => nil}

      %{"errors" => %{"balance" => ["can't be blank"]}} =
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

  describe "transaction/2" do
    test "successfully transacts an account when data is valid", ctx do
      %{id: user_id} = insert(:user)
      %{account_number: account_number} = insert(:account, user_id: user_id)

      params = %{
        "operation_type" => "transference",
        "to_account" => account_number,
        "form_account" => account_number,
        "value" => "100"
      }

      assert %{
               "data" => %{
                 "transaction_type" => "transference",
                 "status" => "success",
                 "to_account" => ^account_number,
                 "form_account" => ^account_number,
                 "value" => "100",
                 "date" => _
               }
             } =
               ctx.conn
               |> post("#{@base_url}/transaction", params)
               |> json_response(:ok)
    end
  end
end
