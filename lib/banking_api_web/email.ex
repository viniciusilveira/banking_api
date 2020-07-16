defmodule BankingApiWeb.Email do
  require Logger

  def send(
        %{email: email},
        %{
          type: type,
          value: value,
          assignor_checking_account: assignor_checking_account
        }
      ) do
    message = message(type, value, assignor_checking_account)

        """
        Typically, we'd send an email here, but for the purposes of this
        demo, show the message on the console:
        """
    Logger.info("""
    Destinatário: #{email}
    #{message}
    """)

    {:ok, message}
  end

  def send(_, _), do: {:error, :not_send}

  defp message(type, value, assignor_checking_account) do
    value = :io_lib.format("~.2f", [value / 100])

    case type do
      "transfer" ->
        "Transferência no valor de R$#{value} enviada para conta #{
          assignor_checking_account.number
        }"

      "withdrawal" ->
        "Saque no valor de R$#{value} executado"

      "deposit" ->
        "Depósito no valor de R$#{value} executado"
    end
  end
end
