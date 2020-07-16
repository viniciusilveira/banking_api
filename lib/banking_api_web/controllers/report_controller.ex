defmodule BankingApiWeb.ReportController do
  use BankingApiWeb, :controller

  alias BankingApi.Transactions
  alias BankingApi.Accounts.User

  action_fallback BankingApiWeb.FallbackController

  def index(conn, _params) do
    with %User{} <- Guardian.Plug.current_resource(conn),
         report <- Transactions.report() do
      render(conn, "index.json", report: report)
    end
  end
end
