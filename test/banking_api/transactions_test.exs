defmodule BankingApi.TransactionTest do
  use BankingApi.DataCase
  import BankingApi.Factory

  alias BankingApi.Transactions
  alias BankingApi.Transactions.Transaction

  describe "transactions" do
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

    test "create_transaction/1 with greater value than available" do
      checking_account = insert(:checking_account)
      attrs = string_params_for(:withdrawal, value: checking_account.balance + 10_000)

      assert {:error, :insufficient_funds} =
               Transactions.create_transaction(attrs, checking_account)
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

  describe "transfer transactions" do
    test "create_transaction/1 with valid data creates a transaction" do
      assignor_checking_account = insert(:checking_account)
      drawee_checking_account = insert(:checking_account)
      attrs = string_params_for(:transfer)

      attrs =
        Map.merge(attrs, %{
          "drawee_checking_account_id" => drawee_checking_account.id,
          "assignor_checking_account_number" => assignor_checking_account.number
        })

      assert {:ok, %Transaction{} = transaction} =
               Transactions.create_transaction(attrs, assignor_checking_account)

      assert transaction.type == attrs["type"]
      assert transaction.value == attrs["value"]
    end

    test "create_transaction/1 with greater value than available" do
      assignor_checking_account = insert(:checking_account)
      drawee_checking_account = insert(:checking_account)
      attrs = string_params_for(:transfer, value: drawee_checking_account.balance + 10_000)

      attrs =
        Map.merge(attrs, %{
          "drawee_checking_account_id" => drawee_checking_account.id,
          "assignor_checking_account_number" => assignor_checking_account.number
        })

      assert {:error, :insufficient_funds} =
               Transactions.create_transaction(attrs, assignor_checking_account)
    end
  end
end
