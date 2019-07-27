# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :banking_api,
  ecto_repos: [BankingApi.Repo]

# Configures the endpoint
config :banking_api, BankingApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZflInU6GfTCBtYa1wU7WvLWPPJG5epH56zjeYr7J5q6BOItiCKEGXCDUXRb7BYai",
  render_errors: [view: BankingApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BankingApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :banking_api, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      # phoenix routes will be converted to swagger paths
      router: BankingApiWeb.Router,
      # (optional) endpoint config used to set host, port and https schemes.
      endpoint: BankingApiWeb.Endpoint
    ]
  }

config :banking_api, BankingApi.Guardian,
  issuer: "bankingApi",
  secret_key: "RZRHk8FicoGygna7RBcb89h62OKsIwP5vRfAsmb4QEtojIt93vqsv3hQP3uDBIM1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
