defmodule BankingApi.TransactionTest do
  use BankingApi.DataCase
  import BankingApi.Factory

  alias BankingApi.Transactions
  alias BankingApi.Transactions.Transaction

  describe "transactions" do
    test "list_transactions/0 returns all transactions" do
      transaction = insert(:withdrawal)
      assert [return_transaction] = Transactions.list_transactions()

      assert return_transaction.id == transaction.id
      assert return_transaction.value == transaction.value
      assert return_transaction.type == transaction.type
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = insert(:withdrawal)
      assert return_transaction = Transactions.get_transaction!(transaction.id)

      assert return_transaction.id == transaction.id
      assert return_transaction.value == transaction.value
      assert return_transaction.type == transaction.type
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = build(:withdrawal)
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end

  describe "withdrawal transactions" do
    test "create_transaction/1 with valid data creates a transaction" do
      checking_account = insert(:checking_account)
      attrs = string_params_for(:withdrawal)

      assert {:ok, %Transaction{} = transaction} =
               Transactions.create_transaction(attrs, checking_account)

      assert transaction.type == attrs["type"]
      assert transaction.value == attrs["value"]
    end
  end

  describe "deposit transactions" do
    test "create_transaction/1 with valid data creates a transaction" do
      checking_account = insert(:checking_account)
      attrs = string_params_for(:deposit)

      assert {:ok, %Transaction{} = transaction} =
               Transactions.create_transaction(attrs, checking_account)

      assert transaction.type == attrs["type"]
      assert transaction.value == attrs["value"]
    end
  end
end
