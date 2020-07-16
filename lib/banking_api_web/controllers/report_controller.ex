defmodule BankingApiWeb.ReportController do
  use BankingApiWeb, :controller

  alias BankingApi.Transactions

  def index(conn, _params) do
    with {:ok, report} <- Transactions.report() do
      render(conn, "index.json", report: report)
    else
      {:error, :no_transactions} ->
        render(conn, "index.json", report: %{})
    end
  end
end
