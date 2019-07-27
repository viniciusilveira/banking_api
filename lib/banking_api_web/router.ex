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

    get "/user", UserController, :show
  end

  scope "/api/documentation" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :banking_api,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Banking Api"
      }
    }
  end
end
