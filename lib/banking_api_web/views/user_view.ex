defmodule BankingApiWeb.UserView do
  use BankingApiWeb, :view
  alias BankingApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{jwt: token, user: user} = data) do
    %{data: render_one(data, UserView, "user.json")}
  end

  def render("user.json", %{jwt: token, user: user}) do
    %{
      user: %{
        id: user.id,
        mail: user.email,
        name: user.name
      },
      checking_account: %{
        id: user.checking_account.id,
        number: user.checking_account.number,
        balance: user.checking_account.balance
      },
      token: token
    }
  end
end
