defmodule GuedesBankWeb.UsersControllerTest do
  use GuedesBankWeb.ConnCase, async: true

  alias GuedesBank.Repo
  alias GuedesBank.Users.Schema.User

  @base_url "/api/users"

  describe "create/2" do
    setup do
      params = %{
        "name" => "Bruno Guedes",
        "email" => "bruno@guedes.com",
        "password" => "123456",
        "password_confirmation" => "123456",
        "cep" => "69905080"
      }

      {:ok, params: params}
    end

    test "successfully creates an user when data is valid", ctx do
      assert %{
               "data" => %{
                 "cep" => "69905080",
                 "email" => "bruno@guedes.com",
                 "id" => _,
                 "name" => "Bruno Guedes"
               }
             } =
               ctx.conn
               |> post(@base_url, ctx.params)
               |> json_response(:created)
    end

    test "returns an error when data is invalid", ctx do
      params = %{
        "name" => "BG",
        "email" => "invalid",
        "password" => "12345",
        "password_confirmation" => "123123",
        "cep" => "69905"
      }

      assert %{
               "errors" => %{
                 "cep" => ["should be 8 character(s)"],
                 "email" => ["has invalid format"],
                 "name" => ["should be at least 3 character(s)"],
                 "password" => ["should be at least 6 character(s)"],
                 "password_confirmation" => ["does not match confirmation"]
               }
             } ==
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:bad_request)
    end

    test "returns an error when exists an user with the same email", ctx do
      ctx.params
      |> User.changeset()
      |> Repo.insert()

      params = Map.put(ctx.params, "name", "Joe Doe")

      assert %{
               "errors" => %{
                 "email" => ["has already been taken"]
               }
             } ==
               ctx.conn
               |> post(@base_url, params)
               |> json_response(:bad_request)
    end
  end

  describe "show/2" do
    test "returns an user", ctx do
      %{id: user_id} = insert(:user, name: "Bruno Guedes", email: "bruno@guedes.com")
      insert_list(4, :user)

      assert %{
               "data" => %{
                 "cep" => "12345678",
                 "email" => "bruno@guedes.com",
                 "id" => ^user_id,
                 "name" => "Bruno Guedes"
               }
             } =
               ctx.conn
               |> get("#{@base_url}/#{user_id}")
               |> json_response(:ok)

      list_users = Repo.all(User)
      assert length(list_users) == 5
    end

    test "returns an error when id is invalid", ctx do
      assert %{"error" => "User not found"} =
               ctx.conn
               |> get("#{@base_url}/0")
               |> json_response(:not_found)
    end
  end

  describe "update/2" do
    test "successfully update an user when data is valid", ctx do
      %{id: user_id} = insert(:user)

      params = %{
        "name" => "Bruno Guedes",
        "email" => "bruno@guedes.com"
      }

      assert %{
               "data" => %{
                 "cep" => "12345678",
                 "email" => "bruno@guedes.com",
                 "id" => ^user_id,
                 "name" => "Bruno Guedes"
               }
             } =
               ctx.conn
               |> put("#{@base_url}/#{user_id}", params)
               |> json_response(:ok)
    end

    test "returns an error when id is invalid", ctx do
      assert %{"error" => "User not found"} =
               ctx.conn
               |> put("#{@base_url}/0", %{})
               |> json_response(:not_found)
    end

    test "returns error when trying to update email that already exists for another user", ctx do
      insert(:user, name: "Bruno Guedes", email: "bruno@guedes.com")
      %{id: user_id} = insert(:user, name: "Joe Doe", email: "joe@guedes.com")

      params = %{"email" => "bruno@guedes.com"}

      assert %{"errors" => %{"email" => ["has already been taken"]}} =
               ctx.conn
               |> put("#{@base_url}/#{user_id}", params)
               |> json_response(:bad_request)
    end
  end

  describe "delete/2" do
    test "successfully deletes a user when id is valid", ctx do
      %{id: user_id} = insert(:user)

      assert %{"data" => %{"cep" => _, "email" => _, "id" => ^user_id, "name" => _}} =
               ctx.conn
               |> delete("#{@base_url}/#{user_id}")
               |> json_response(:ok)

      assert Repo.get(User, user_id) == nil
    end

    test "returns an error when id is invalid", ctx do
      assert %{"error" => "User not found"} =
               ctx.conn
               |> delete("#{@base_url}/0")
               |> json_response(:not_found)
    end
  end
end
