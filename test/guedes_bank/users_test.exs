defmodule GuedesBank.UsersTest do
  use GuedesBank.DataCase, async: true
  import Mox

  alias GuedesBank.ExternalClient.ViaCepMock
  alias GuedesBank.Users
  alias GuedesBank.Users.Inputs.CreateUser
  alias GuedesBank.Users.Inputs.UpdateUser
  alias GuedesBank.Users.Schema.User

  describe "create_user" do
    test "successfully create user" do
      expect(ViaCepMock, :call, fn _cep ->
        {:ok, %{}}
      end)

      params = %CreateUser{
        name: "Bruno Guedes",
        email: "bruno@guedes.com",
        password: "123456",
        password_confirmation: "123456",
        cep: "69905080"
      }

      assert {:ok, %User{}} = Users.create_user(params)
    end

    test "fail to create user when exists an user with the same email" do
      expect(ViaCepMock, :call, fn _cep ->
        {:ok, %{}}
      end)

      %{email: email} = insert(:user, email: "bruno@guedes.com")

      params = %CreateUser{
        name: "Bruno Guedes",
        email: email,
        password: "123456",
        password_confirmation: "123456",
        cep: "69905080"
      }

      assert assert {:error, %{errors: [email: {"has already been taken", _}]}} =
                      Users.create_user(params)
    end
  end

  describe "update_user" do
    test "successfully update user" do
      %{id: user_id} = insert(:user, name: "Bruno", email: "email@guedes.com")

      params = %UpdateUser{
        id: user_id,
        name: "Bruno Guedes",
        email: "updated_email@guedes.com"
      }

      assert {:ok, %User{id: ^user_id}} = Users.update_user(params)
    end

    test "fail to update user when user_id not exists" do
      params = %UpdateUser{
        id: Enum.random(1..100)
      }

      assert {:error, :user_not_found} == Users.update_user(params)
    end

    test "fail to update user when email already exists" do
      %{email: email} = insert(:user)
      %{id: user_id} = insert(:user)

      params = %UpdateUser{
        id: user_id,
        email: email
      }

      assert {:error, %{errors: [email: {"has already been taken", _}]}} =
               Users.update_user(params)
    end
  end

  describe "delete_user" do
    test "successfully delete user" do
      %{id: user_id} = insert(:user)

      id = Integer.to_string(user_id)
      assert {:ok, %User{id: ^user_id}} = Users.delete_user(id)
      assert {:error, :user_not_found} = Users.get(id)
    end

    test "fail to delete user when user_id not exists" do
      id = Enum.random(1..100) |> Integer.to_string()
      assert {:error, :user_not_found} == Users.delete_user(id)
    end
  end

  describe "get_user" do
    test "get user by id" do
      %{id: user_id} = insert(:user)

      assert {:ok, %User{id: ^user_id}} = Users.get(user_id)
    end

    test "fail to get user when user_id not exists" do
      assert {:error, :user_not_found} == Users.get(Enum.random(1..100))
    end
  end

  describe "get_by_user" do
    test "successfully get user by filter" do
      %{email: email, name: name} = insert(:user)
      insert_list(4, :user)

      assert {:ok, %User{email: ^email, name: ^name}} = Users.get_by(%{email: email, name: name})
    end
  end

  describe "user_exists?" do
    test "check if user exists" do
      %{id: user_id, email: email} = insert(:user)
      insert_list(4, :user)

      assert Users.exists?(%{id: user_id, email: email}) == true
      assert Users.exists?(%{email: "banana"}) == false
    end
  end
end
