defmodule BankingApi.CheckingAccountsTest do
  use BankingApi.DataCase

  alias BankingApi.CheckingAccounts

  describe "checking_accounts" do
    alias BankingApi.CheckingAccounts.CheckingAccount

    @valid_attrs %{balance: 42, number: "some number"}
    @update_attrs %{balance: 43, number: "some updated number"}
    @invalid_attrs %{balance: nil, number: nil}

    def checking_account_fixture(attrs \\ %{}) do
      {:ok, checking_account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CheckingAccounts.create_checking_account()

      checking_account
    end

    test "list_checking_accounts/0 returns all checking_accounts" do
      checking_account = checking_account_fixture()
      assert CheckingAccounts.list_checking_accounts() == [checking_account]
    end

    test "get_checking_account!/1 returns the checking_account with given id" do
      checking_account = checking_account_fixture()
      assert CheckingAccounts.get_checking_account!(checking_account.id) == checking_account
    end

    test "create_checking_account/1 with valid data creates a checking_account" do
      assert {:ok, %CheckingAccount{} = checking_account} = CheckingAccounts.create_checking_account(@valid_attrs)
      assert checking_account.balance == 42
      assert checking_account.number == "some number"
    end

    test "create_checking_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CheckingAccounts.create_checking_account(@invalid_attrs)
    end

    test "update_checking_account/2 with valid data updates the checking_account" do
      checking_account = checking_account_fixture()
      assert {:ok, %CheckingAccount{} = checking_account} = CheckingAccounts.update_checking_account(checking_account, @update_attrs)
      assert checking_account.balance == 43
      assert checking_account.number == "some updated number"
    end

    test "update_checking_account/2 with invalid data returns error changeset" do
      checking_account = checking_account_fixture()
      assert {:error, %Ecto.Changeset{}} = CheckingAccounts.update_checking_account(checking_account, @invalid_attrs)
      assert checking_account == CheckingAccounts.get_checking_account!(checking_account.id)
    end

    test "delete_checking_account/1 deletes the checking_account" do
      checking_account = checking_account_fixture()
      assert {:ok, %CheckingAccount{}} = CheckingAccounts.delete_checking_account(checking_account)
      assert_raise Ecto.NoResultsError, fn -> CheckingAccounts.get_checking_account!(checking_account.id) end
    end

    test "change_checking_account/1 returns a checking_account changeset" do
      checking_account = checking_account_fixture()
      assert %Ecto.Changeset{} = CheckingAccounts.change_checking_account(checking_account)
    end
  end
end
