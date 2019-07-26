defmodule BankingApi.AccountsTest do
  use BankingApi.DataCase

  alias BankingApi.Accounts

  import BankingApi.Factory

  describe "users" do
    alias BankingApi.Accounts.User

    @valid_attrs params_for(:user)
    @invalid_attrs %{email: nil, name: nil, password_hash: nil}

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == @valid_attrs.email
      assert user.name == @valid_attrs.name
      assert user.password_hash == @valid_attrs.password_hash
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end
  end
end
