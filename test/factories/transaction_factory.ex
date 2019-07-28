defmodule BankingApi.TransactionFactory do
  alias BankingApi.Transactions.Transaction

  defmacro __using__(_opts) do
    quote do
      def withdrawal_factory do
        %Transaction{
          value: 10_000,
          drawee_checking_account: insert(:checking_account),
          type: "withdrawal"
        }
      end
    end
  end
end
