defmodule GuedesBank.AccountsTest do
  use GuedesBank.DataCase

  alias GuedesBank.Accounts
  alias GuedesBank.Accounts.Inputs.CreateAccount
  alias GuedesBank.Accounts.Schema.Account

  describe "create_account/1" do
    test "success, create account when data is valid" do
      %{id: user_id} = insert(:user)

      assert {:ok, %{id: _, user_id: ^user_id, balance: _, account_number: _}} =
               Accounts.create_account(%CreateAccount{balance: 0, user_id: user_id})
    end

    test "fail, when the balance is negative" do
      %{id: user_id} = insert(:user)

      assert {:error,
              %{
                errors: [
                  balance:
                    {"is invalid",
                     [constraint: :check, constraint_name: "balance_must_be_positive"]}
                ]
              }} = Accounts.create_account(%CreateAccount{balance: -10, user_id: user_id})
    end

    test "fail, user not found" do
      assert {:error, :user_not_found} ==
               Accounts.create_account(%CreateAccount{balance: 0, user_id: 1})
    end
  end

  describe "get_account/1" do
    test "success, get account when data is valid" do
      %{id: user_id} = insert(:user)
      %{id: account_id} = insert(:account, user_id: user_id)

      assert {:ok, %{id: ^account_id, user_id: ^user_id, balance: _, account_number: _}} =
               Accounts.get(account_id)
    end

    test "fail, account not found" do
      assert {:error, :account_not_found} == Accounts.get(1)
    end
  end

  describe "get_by/1" do
    test "success, get account when data is valid" do
      %{id: user_id} = insert(:user)
      %{id: account_id} = insert(:account, user_id: user_id)
      insert_list(4, :account)

      assert {:ok, %{id: ^account_id, user_id: ^user_id, balance: _, account_number: _}} =
               Accounts.get_by(user_id: user_id, id: account_id)

      assert Repo.all(Account) |> length == 5
    end

    test "fail, account not found" do
      assert {:error, :account_not_found} == Accounts.get_by(user_id: 1, id: 1)
    end
  end

  describe "exists?/1" do
    test "check if account exists" do
      %{id: user_id} = insert(:user)
      %{account_number: account_number} = insert(:account, user_id: user_id)

      assert true == Accounts.exists?(account_number: account_number, user_id: user_id)
      assert false == Accounts.exists?(account_number: "00000")
    end
  end

  describe "transaction" do
    test "success, can transference between accounts" do
      %{id: to_user_id} = insert(:user)

      %{id: from_user_id} = insert(:user)

      %{id: from_account_id, account_number: from_account_number} =
        insert(:account, user_id: from_user_id)

      %{id: to_account_id, account_number: to_account_number} =
        insert(:account, user_id: to_user_id, balance: Decimal.new("100"))

      params = %{
        operation_type: :transference,
        to_account: to_account_number,
        form_account: from_account_number,
        value: "50.50"
      }

      assert {:ok,
              %{
                status: :success,
                value: _,
                date: _,
                to_account: ^to_account_number,
                form_account: ^from_account_number,
                transaction_type: :transference
              }} = Accounts.transaction(params)

      assert Repo.get(Account, from_account_id) |> Map.get(:balance) == Decimal.new("50.50")
      assert Repo.get(Account, to_account_id) |> Map.get(:balance) == Decimal.new("49.50")
    end

    test "fail, when value is negative" do
      %{account_number: from_account_number} = insert(:account)
      %{account_number: to_account_number} = insert(:account)

      params = %{
        operation_type: :transference,
        to_account: to_account_number,
        form_account: from_account_number,
        value: "-100"
      }

      assert {
               :error,
               %{
                 errors: [
                   balance:
                     {"is invalid",
                      [constraint: :check, constraint_name: "balance_must_be_positive"]}
                 ]
               }
             } = Accounts.transaction(params)
    end

    test "fail, when value is invalid" do
      %{account_number: from_account_number} = insert(:account)
      %{account_number: to_account_number} = insert(:account)

      params = %{
        operation_type: :transference,
        to_account: to_account_number,
        form_account: from_account_number,
        value: "invalid value"
      }

      assert {:error, :invalid_value} == Accounts.transaction(params)
    end

    test "fail, when to_account don't have enough balance" do
      %{account_number: from_account_number} = insert(:account, balance: Decimal.new("0"))
      %{account_number: to_account_number} = insert(:account)

      params = %{
        operation_type: :transference,
        to_account: to_account_number,
        form_account: from_account_number,
        value: "100"
      }

      assert {:error, :balance_must_be_positive} = Accounts.transaction(params)
    end

    test "fail, when from_account not found" do
      %{account_number: to_account_number} = insert(:account)

      params = %{
        operation_type: :transference,
        to_account: to_account_number,
        form_account: "00000",
        value: "100"
      }

      assert {:error, :account_not_found} == Accounts.transaction(params)
    end

    test "fail, when to_account not found" do
      %{account_number: from_account_number} = insert(:account, balance: Decimal.new("100"))

      params = %{
        operation_type: :transference,
        to_account: "00000",
        form_account: from_account_number,
        value: "100"
      }

      assert {:error, :account_not_found} == Accounts.transaction(params)
    end
  end
end
