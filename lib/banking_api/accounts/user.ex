defmodule BankingApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(email name password_hash)a

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
  end
end
