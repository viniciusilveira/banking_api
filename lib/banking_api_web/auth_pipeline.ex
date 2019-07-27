defmodule BankingApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :banking_api,
    module: BankingApi.Guardian,
    error_handler: BankingApi.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
