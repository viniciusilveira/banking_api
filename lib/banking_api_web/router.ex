defmodule BankingApiWeb.Router do
  use BankingApiWeb, :router

  alias BankingApi.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api", BankingApiWeb do
    pipe_through :api

    post "/sign_up", UserController, :create
    post "/sign_in", UserController, :sign_in
  end

  scope "/api", BankingApiWeb do
    pipe_through [:api, :jwt_authenticated]

    resources "/transactions", TransactionController, only: [:create, :index, :show]

    scope "/backoffice" do
      get "/report", TransactionController, :report, as: :report
    end
  end
end
