defmodule BankingApiWeb.ReportView do
  use BankingApiWeb, :view

  def render("index.json", %{report: report}) do
    %{data: report}
  end
end
