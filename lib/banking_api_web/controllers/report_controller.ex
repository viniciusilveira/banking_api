defmodule BankingApiWeb.ReportController do
  use BankingApiWeb, :controller

  alias BankingApi.Transactions

  def index(conn, _params) do
    case Transactions.report() do
      {:ok, report} ->
        render(conn, "index.json", report: report)

      {:error, :no_transactions} ->
        render(conn, "index.json", report: %{})
    end
  end
end
