defmodule BankingApiWeb.TransactionController do
  use BankingApiWeb, :controller

  alias BankingApi.CheckingAccounts
  alias BankingApi.CheckingAccounts.CheckingAccount
  alias BankingApi.Transactions
  alias BankingApi.Transactions.Transaction
  alias BankingApi.Accounts.User
  alias BankingApiWeb.Email

  action_fallback BankingApiWeb.FallbackController

  def create(conn, %{"transaction" => %{"type" => "withdrawal"} = transaction_params}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         %CheckingAccount{} = drawee_checking_account <-
           CheckingAccounts.get_checking_account_by_user_and_number(
             user.id,
             transaction_params["drawee_checking_account_number"]
           ),
         {:ok, %Transaction{} = transaction} <-
           Transactions.create_transaction(transaction_params, drawee_checking_account),
         _pid <- spawn(Email, :send, [user, transaction]) do
      render_show(conn, transaction)
    end
  end

  def create(conn, %{"transaction" => %{"type" => "deposit"} = transaction_params}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         %CheckingAccount{} = assignor_checking_account <-
           CheckingAccounts.get_checking_account_by_number(
             transaction_params["assignor_checking_account_number"]
           ),
         {:ok, %Transaction{} = transaction} <-
           Transactions.create_transaction(transaction_params, assignor_checking_account),
         _pid <- spawn(Email, :send, [user, transaction]) do
      render_show(conn, transaction)
    end
  end

  def create(conn, %{"transaction" => %{"type" => "transfer"} = transaction_params}) do
    with %User{} = user <- Guardian.Plug.current_resource(conn),
         %CheckingAccount{} = drawee_checking_account <-
           CheckingAccounts.get_checking_account_by_user_and_number(
             user.id,
             transaction_params["drawee_checking_account_number"]
           ),
         {:ok, %Transaction{} = transaction} <-
           Transactions.create_transaction(transaction_params, drawee_checking_account),
         _pid <- spawn(Email, :send, [user, transaction]) do
      render_show(conn, transaction)
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    render(conn, "show.json", transaction: transaction)
  end

  defp render_show(conn, transaction) do
    conn
    |> put_status(:created)
    |> put_resp_header("location", Routes.transaction_path(conn, :show, transaction))
    |> render("show.json", transaction: transaction)
  end
end
