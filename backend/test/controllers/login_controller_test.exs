import Backend.TestUtil

defmodule Backend.LoginControllerTest do
  use Backend.ConnCase
  
  @invalid_attrs %{email: "craa@gordo", password: "streetGordo"}
                            
  setup %{conn: conn} do
    {:ok, conn: conn |> login_with_random_user}
  end
  
  
  test "for 200 when POST /login with valid credentials", %{conn: conn} do
    assert conn.jwt |> is_binary
  end

  test "for 401 when POST /login with invalid credentials", %{conn: conn} do
    conn = post conn, login_path(conn, :login), @invalid_attrs
    assert json_response(conn, 401) == %{"error" => "invalid credentials"}
  end
  
  test "for 204 when DELETE /login with valid credentials", %{conn: conn} do
    conn = conn
    |> delete login_path(conn, :logout)
    
    assert response(conn, 204) == ""
    
    conn_ = conn
    |> get user_path(conn, :index)
    
    assert json_response(conn_, 401) == %{ "error" => "missing JWT in header" }
  end
  
  test "for 401 when DELETE /login with invalid credentials", %{conn: conn} do
    conn = conn 
    |> put_req_header("authorization", "Bearer Super Breno Magro")
    |> delete login_path(conn, :logout)
    
    assert json_response(conn, 401) == %{ "error" => "missing JWT in header" }
  end
  
  test "for 201 when POST /forgot-password with valid email", %{conn: conn} do
    conn = conn
    |> post login_path(conn, :forgot_password), %{"email" => conn.user.email}
    
    assert response(conn, 201) == ""
  end
  
  test "for 404 when POST /forgot-password with invalid email" %{conn: conn} do
    conn = conn
    |> post login_path(conn, :forgot_password), %{"email" => "street@craa"}
    
    assert json_response(conn, 404) == %{"error" => "email not found"}
    
  end
  
  test "for 201 when GET /forgot-password with valid link" %{conn: conn} do
    conn = conn
    |> get login_path(conn, :validate_link)
    
    assert response(conn, 200) == ""
    
  end
  #
  #test "for 404 when GET /forgot-password with invalid link" do
  #  conn = conn
  #  |> get login_path(conn, :validate_link)
  #  
  #  assert (conn, 404) == ""
  #  
  #  assert conn.jwt |> is_binary
  #  
  #end
end