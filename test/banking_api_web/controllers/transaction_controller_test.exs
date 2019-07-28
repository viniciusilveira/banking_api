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

    test "withdrawal transaction renders error when greater value than available", %{
      conn: conn,
      user: user
    } do
      transaction_attrs = params_for(:withdrawal)
      checking_account = user.checking_account

      create_attrs = %{
        value: transaction_attrs.value + checking_account.balance,
        drawee_checking_account_number: checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Modified"}} == json_response(conn, 304)
    end

    test "withdrawal transaction renders error when value is negative number", %{
      conn: conn,
      user: user
    } do
      transaction_attrs = params_for(:withdrawal, value: -100)
      checking_account = user.checking_account

      create_attrs = %{
        value: transaction_attrs.value,
        drawee_checking_account_number: checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Modified"}} == json_response(conn, 304)
    end

    test "withdrawal transaction renders error when checking account does not exist", %{
      conn: conn,
      user: user
    } do
      transaction_attrs = params_for(:withdrawal)
      checking_account = user.checking_account

      create_attrs = %{
        value: transaction_attrs.value + checking_account.balance,
        drawee_checking_account_number: "00000",
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "renders deposit transaction when data is valid and checking account as same user authenticated",
         %{conn: conn, user: user} do
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

    test "renders deposit transaction when data is valid and checking account is do another user",
         %{conn: conn} do
      transaction_attrs = params_for(:deposit)
      checking_account = insert(:checking_account)

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

    test "deposit transaction renders error when checking account does not exist", %{
      conn: conn
    } do
      transaction_attrs = params_for(:deposit)

      create_attrs = %{
        value: transaction_attrs.value,
        assignor_checking_account_number: "0000000",
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "deposit transaction renders error when value is negative", %{
      conn: conn,
      user: user
    } do
      transaction_attrs = params_for(:deposit, value: -100)

      create_attrs = %{
        value: transaction_attrs.value,
        assignor_checking_account_number: user.checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Modified"}} == json_response(conn, 304)
    end

    test "renders transfer transaction when data is valid", %{conn: conn, user: user} do
      transaction_attrs = params_for(:transfer)
      drawee_checking_account = user.checking_account
      assignor_checking_account = insert(:checking_account)

      create_attrs = %{
        value: transaction_attrs.value,
        drawee_checking_account_number: drawee_checking_account.number,
        assignor_checking_account_number: assignor_checking_account.number,
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

    test "transfer transaction renders error when drawee checking account does not exist", %{
      conn: conn
    } do
      transaction_attrs = params_for(:transfer)
      assignor_checking_account = insert(:checking_account)

      create_attrs = %{
        value: transaction_attrs.value,
        drawee_checking_account_number: "000000",
        assignor_checking_account_number: assignor_checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "transfer transaction renders error when assignor checking account does not exist", %{
      conn: conn
    } do
      transaction_attrs = params_for(:transfer)
      drawee_checking_account = insert(:checking_account)

      create_attrs = %{
        value: transaction_attrs.value,
        drawee_checking_account_number: drawee_checking_account.number,
        assignor_checking_account_number: "000000",
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)
      assert %{"errors" => %{"detail" => "Not Found"}} = json_response(conn, 404)
    end

    test "transfer transaction renders error when value is a negative", %{
      conn: conn,
      user: user
    } do
      transaction_attrs = params_for(:transfer, value: -100)
      drawee_checking_account = user.checking_account
      assignor_checking_account = insert(:checking_account)

      create_attrs = %{
        value: transaction_attrs.value,
        drawee_checking_account_number: drawee_checking_account.number,
        assignor_checking_account_number: assignor_checking_account.number,
        type: transaction_attrs.type
      }

      conn = post(conn, Routes.transaction_path(conn, :create), transaction: create_attrs)

      assert %{"errors" => %{"detail" => "Not Modified"}} == json_response(conn, 304)
    end
  end
end
