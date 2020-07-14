defmodule BankingApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias BankingApi.Accounts.User
  alias BankingApi.CheckingAccounts.CheckingAccount

  @required_fields ~w(email name password password_confirmation)a

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    belongs_to :checking_account, CheckingAccount

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> cast_assoc(:checking_account)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
