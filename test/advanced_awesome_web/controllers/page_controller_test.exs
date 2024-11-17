defmodule AdvancedAwesomeWeb.LibrariesControllerTest do
  use AdvancedAwesomeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ ""
  end

  test "GET / with min_stars parameter", %{conn: conn} do
    conn = get(conn, "/?min_stars=1000")
    assert html_response(conn, 200) =~ ""
  end

  test "GET / with min_stars parameter as a string", %{conn: conn} do
    conn = get(conn, "/?min_stars=invalid_value")
    assert html_response(conn, 200) =~ ""
  end
end
