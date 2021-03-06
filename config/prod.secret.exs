use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :banking_api, BankingApiWeb.Endpoint,
  secret_key_base: "4bTZVsAbuvo9832OPUSrrEft0RrLqQ5bC6PNOjQz4hURxECXBp0UYHPhzngjXdB6"

# Configure your database
config :banking_api, BankingApi.Repo,
  ssl: true,
  url: System.get_env("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
