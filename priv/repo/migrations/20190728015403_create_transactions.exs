defmodule BankingApi.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :value, :integer
      add :type, :string
      add :assignor_checking_account_id, references(:checking_accounts, on_delete: :nothing)
      add :drawee_checking_account_id, references(:checking_accounts, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:assignor_checking_account_id])
    create index(:transactions, [:drawee_checking_account_id])
  end
end
