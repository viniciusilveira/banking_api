defmodule BankingApiWeb.UserView do
  use BankingApiWeb, :view
  alias BankingApiWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user, jwt: token}) do
    %{data: render(UserView, "user.json", %{user: user, jwt: token})}
  end

  def render("show.json", %{admin: admin, jwt: token}) do
    %{data: render(UserView, "admin.json", %{admin: admin, jwt: token})}
  end

  def render("user.json", %{user: user, jwt: token}) do
    %{
      user: %{
        id: user.id,
        email: user.email,
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

  def render("admin.json", %{admin: admin, jwt: token}) do
    %{
      admin: %{
        id: admin.id,
        email: admin.email,
        name: admin.name
      },
      token: token
    }
  end

  def render("jwt.json", %{jwt: token}) do
    %{
      jwt: token
    }
  end
end
