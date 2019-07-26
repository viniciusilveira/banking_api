defmodule BankingApiWeb.UserControllerTest do
  use BankingApiWeb.ConnCase

  import BankingApi.Factory

  @create_attrs params_for(:user)
  @invalid_attrs %{email: nil, name: nil, password_hash: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert response = json_response(conn, 200)["data"]

      assert response["email"] == @create_attrs.email
      assert response["name"] == @create_attrs.name
      assert response["password_hash"] == @create_attrs.password_hash
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
