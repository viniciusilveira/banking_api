defmodule BankingApi.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias BankingApi.Repo

  alias BankingApi.CheckingAccounts
  alias BankingApi.CheckingAccounts.CheckingAccount
  alias BankingApi.Transactions.Transaction

  def report do
    daily = daily_total()

    case daily do
      nil ->
        {:ok, :no_transactions}

      _ ->
        total =
          daily
          |> Enum.map(fn d -> d.total end)
          |> Enum.sum()

        %{
          daily: daily,
          monthly: monthly_total(daily),
          yearly: yearly_total(daily),
          total: total
        }
    end
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value}, %CheckingAccount{})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value}, %CheckingAccount{})
      {:error, %Ecto.Changeset{}}

      iex> create_transaction(%{field: bad_value}, %CheckingAccount{})
      {:error, :insufficient_funds}

  """
  def create_transaction(
        %{"type" => "withdrawal"} = attrs,
        %CheckingAccount{} = drawee_checking_account
      ) do
    with {:ok, :valid} <- validate_transaction_value(attrs),
         true <- CheckingAccounts.validate_balance(drawee_checking_account, attrs["value"]),
         {:ok, %CheckingAccount{}} <-
           CheckingAccounts.update_checking_account(drawee_checking_account, %{
             balance: drawee_checking_account.balance - attrs["value"]
           }) do
      attrs = Map.merge(attrs, %{"drawee_checking_account_id" => drawee_checking_account.id})

      do_create_transaction(attrs)
    else
      false -> {:error, :insufficient_funds}
      error -> error
    end
  end

  def create_transaction(
        %{"type" => "deposit"} = attrs,
        %CheckingAccount{} = assignor_checking_account
      ) do
    with {:ok, :valid} <- validate_transaction_value(attrs),
         {:ok, %CheckingAccount{}} <-
           CheckingAccounts.update_checking_account(assignor_checking_account, %{
             balance: assignor_checking_account.balance + attrs["value"]
           }) do
      attrs = Map.merge(attrs, %{"assignor_checking_account_id" => assignor_checking_account.id})

      do_create_transaction(attrs)
    else
      error -> error
    end
  end

  def create_transaction(
        %{"type" => "transfer"} = attrs,
        %CheckingAccount{} = drawee_checking_account
      ) do
    with {:ok, :valid} <- validate_transaction_value(attrs),
         true <- CheckingAccounts.validate_balance(drawee_checking_account, attrs["value"]),
         %CheckingAccount{} = assignor_checking_account <-
           CheckingAccounts.get_checking_account_by_number(
             attrs["assignor_checking_account_number"]
           ),
         {:ok, %CheckingAccount{}} <-
           CheckingAccounts.update_checking_account(drawee_checking_account, %{
             balance: drawee_checking_account.balance - attrs["value"]
           }),
         {:ok, %CheckingAccount{}} <-
           CheckingAccounts.update_checking_account(assignor_checking_account, %{
             balance: assignor_checking_account.balance + attrs["value"]
           }) do
      attrs =
        Map.merge(attrs, %{
          "assignor_checking_account_id" => assignor_checking_account.id,
          "drawee_checking_account_id" => drawee_checking_account.id
        })

      do_create_transaction(attrs)
    else
      false ->
        {:error, :insufficient_funds}

      error ->
        error
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  defp daily_total do
    query =
      from transaction in Transaction,
        group_by: [
          fragment("?::date", transaction.inserted_at)
        ],
        order_by: [desc: fragment("?::date", transaction.inserted_at)],
        select: %{
          total: fragment("SUM(value)"),
          day: fragment("?::date", transaction.inserted_at)
        }

    Repo.all(query)
  end

  defp monthly_total(daily_total, report \\ %{})
  defp monthly_total([], report), do: report

  defp monthly_total(daily_total, report) do
    first = List.first(daily_total)
    key = "#{first.day.month}/#{first.day.year}"

    mount_report(report, daily_total, key, &monthly_total/2)
  end

  defp yearly_total(daily_total, report \\ %{})
  defp yearly_total([], report), do: report

  defp yearly_total(daily_total, report) do
    key = "#{List.first(daily_total).day.year}"

    mount_report(report, daily_total, key, &yearly_total/2)
  end

  defp mount_report(report, daily_total, key, recursive_function) do
    [first | tail] = daily_total

    case Map.has_key?(report, key) do
      true ->
        total = report[key] + first.total
        recursive_function.(tail, Map.merge(report, %{"#{key}" => total}))

      _ ->
        recursive_function.(tail, Map.merge(report, %{"#{key}" => first.total}))
    end
  end

  defp validate_transaction_value(%{"value" => value}) do
    case value > 0 do
      true -> {:ok, :valid}
      _ -> {:error, :invalid_value}
    end
  end

  defp do_create_transaction(attrs) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end
end
