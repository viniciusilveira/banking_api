defmodule BankingApiWeb.ReportControllerTest do
  use BankingApiWeb.ConnCase
  import BankingApi.Factory

  alias BankingApi.Guardian

  setup %{conn: conn} do
    admin = insert(:admin)
    {:ok, token, _claims} = Guardian.encode_and_sign(admin)
    conn = put_req_header(conn, "authorization", "Bearer #{token}")

    {:ok, conn: put_req_header(conn, "accept", "application/json"), admin: admin}
  end

  describe "index" do
    test "renders transactions report when data is valid", %{conn: conn} do
      insert_list(10, :withdrawal)
      insert_list(10, :deposit)
      insert_list(10, :transfer)
      conn = get(conn, Routes.report_path(conn, :index))

      assert %{
               "daily" => [%{"day" => "2020-07-16", "total" => 300_000}],
               "monthly" => %{"7/2020" => 300_000},
               "total" => 300_000,
               "yearly" => %{"2020" => 300_000}
             } == json_response(conn, 200)["data"]
    end

    test "renders empty map when does not exists transactions", %{conn: conn} do
      conn = get(conn, Routes.report_path(conn, :index))
      %{"data" => %{}} = json_response(conn, 200)
    end

    test "renders unauthorized when current user does not admin", %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      conn = get(conn, Routes.report_path(conn, :index))
      assert %{"error" => "Login error"} == json_response(conn, 401)
    end

    test "renders unauthorized when the user is not logged in ", %{conn: conn} do
      conn = delete_req_header(conn, "authorization")

      conn = get(conn, Routes.report_path(conn, :index))
      assert conn.status == 401
    end
  end
end
