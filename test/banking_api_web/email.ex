defmodule BankingApiWeb.EmailTest do
  use BankingApiWeb.ConnCase
  import BankingApi.Factory

  alias BankingApiWeb.Email

  describe "send" do
    test "send email after deposit operation" do
      user = insert(:user)
      checking_account = insert(:checking_account)

      deposit = insert(:deposit, assignor_checking_account: checking_account)

      assert {:ok, "Depósito no valor de R$100.00 executado"} = Email.send(user, deposit)
    end

    test "send email after withdrawal operation" do
      user = insert(:user)
      checking_account = insert(:checking_account)

      deposit = insert(:withdrawal, assignor_checking_account: checking_account)

      assert {:ok, "Saque no valor de R$100.00 executado"} = Email.send(user, deposit)
    end

    test "send email after transfer operation" do
      user = insert(:user)
      checking_account = insert(:checking_account)

      transfer = insert(:transfer, assignor_checking_account: checking_account)
      message = "Transferência no valor de R$100.00 enviada para conta #{checking_account.number}"

      assert {:ok, message} == Email.send(user, transfer)
    end
  end
end
