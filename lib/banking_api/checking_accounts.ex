defmodule BankingApi.CheckingAccounts do
  @moduledoc """
  The CheckingAccounts context.
  """

  import Ecto.Query, warn: false
  alias BankingApi.Repo

  alias BankingApi.Accounts.User
  alias BankingApi.CheckingAccounts.CheckingAccount

  def generate_number do
    number = String.slice(String.replace(to_string(:rand.uniform()), "0.", ""), 0..10)

    case list_checking_accounts_by_number(number) do
      [] -> number
      _ -> generate_number()
    end
  end

  @doc """
  Returns the list of checking_accounts.

  ## Examples

      iex> list_checking_accounts()
      [%CheckingAccount{}, ...]

  """
  def list_checking_accounts do
    Repo.all(CheckingAccount)
  end

  def list_checking_accounts_by_number(number) do
    query =
      from ca in CheckingAccount,
        where: ca.number == ^number

    Repo.all(query)
  end

  @doc """
  Gets a single checking_account.

  Raises `Ecto.NoResultsError` if the Checking account does not exist.

  ## Examples

      iex> get_checking_account!(123)
      %CheckingAccount{}

      iex> get_checking_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_checking_account!(id), do: Repo.get!(CheckingAccount, id)

  def get_checking_account_by_number(number), do: Repo.get_by(CheckingAccount, number: number)

  def get_checking_account_by_user_and_number(user_id, number) do
    query =
      from user in User,
        join: checking_account in assoc(user, :checking_account),
        where: checking_account.number == ^number,
        where: user.id == ^user_id,
        select: checking_account

    with %CheckingAccount{} = checking_account <- Repo.one(query) do
      checking_account
    else
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Updates a checking_account.

  ## Examples

      iex> update_checking_account(checking_account, %{field: new_value})
      {:ok, %CheckingAccount{}}

      iex> update_checking_account(checking_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_checking_account(%CheckingAccount{} = checking_account, attrs) do
    checking_account
    |> CheckingAccount.changeset(attrs)
    |> Repo.update()
  end

  def validate_balance(%CheckingAccount{} = checking_account, value) do
    checking_account.balance > value
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking checking_account changes.

  ## Examples

      iex> change_checking_account(checking_account)
      %Ecto.Changeset{source: %CheckingAccount{}}

  """
  def change_checking_account(%CheckingAccount{} = checking_account) do
    CheckingAccount.changeset(checking_account, %{})
  end
end
