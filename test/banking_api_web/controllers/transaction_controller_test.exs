defmodule BankingApiWeb.TransactionControllerTest do
  use BankingApiWeb.ConnCase
  import BankingApi.Factory

  alias BankingApi.Guardian

  setup %{conn: conn} do
    checking_account = insert(:checking_account)
    user = insert(:user, checking_account: checking_account)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: put_req_header(conn, "accept", "application/json"), user: user}
  end

  describe "index" do
    test "lists all transactions", %{conn: conn} do
      conn = get(conn, Routes.transaction_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transaction" do
    test "renders withdrawal transaction when data is valid", %{conn: conn, user: user} do
      transaction_attrs = params_for(:withdrawal)
      checking_account = user.checking_account

      create_attrs = %{
        value: transaction_attrs.value,
        drawee_checking_account_number: checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))
      assert response = json_response(conn, 200)["data"]

      assert id == response["id"]
      assert create_attrs.type == response["type"]
      assert create_attrs.value == response["value"]
    end

    test "renders deposit transaction when data is valid", %{conn: conn, user: user} do
      transaction_attrs = params_for(:deposit)
      checking_account = user.checking_account

      create_attrs = %{
        value: transaction_attrs.value,
        assignor_checking_account_number: checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transaction_path(conn, :show, id))
      assert response = json_response(conn, 200)["data"]

      assert id == response["id"]
      assert create_attrs.type == response["type"]
      assert create_attrs.value == response["value"]
    end
  end
end
