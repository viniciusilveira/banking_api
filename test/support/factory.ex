defmodule BankingApi.Factory do
  use ExMachina.Ecto, repo: BankingApi.Repo

  use BankingApi.{
    CheckingAccountFactory,
    UserFactory
  }
end
