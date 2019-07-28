defmodule BankingApiWeb.UserController do
  use BankingApiWeb, :controller

  alias BankingApi.{Accounts, CheckingAccounts}
  alias BankingApi.Accounts.User
  alias BankingApi.Guardian

  action_fallback BankingApiWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    checking_account_params = %{
      "checking_account" => %{number: CheckingAccounts.generate_number(), balance: 100_000}
    }

    with {:ok, %User{} = user} <-
           user_params
           |> Map.merge(checking_account_params)
           |> Accounts.create_user(),
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user) do
      conn |> render("show.json", %{jwt: token, user: user})
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.token_sign_in(email, password) do
      {:ok, token, _claims} ->
        conn |> render("jwt.json", jwt: token)

      _ ->
        {:error, :unauthorized}
    end
  end
end
