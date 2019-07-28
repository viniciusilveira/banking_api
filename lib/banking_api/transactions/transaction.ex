defmodule BankingApi.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias BankingApi.CheckingAccounts.CheckingAccount

  @required_fields ~w(type value)a
  @optional_fields ~w(assignor_checking_account_id drawee_checking_account_id)a

  schema "transactions" do
    field :type, :string
    field :value, :integer
    belongs_to :assignor_checking_account, CheckingAccount
    belongs_to :drawee_checking_account, CheckingAccount

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
