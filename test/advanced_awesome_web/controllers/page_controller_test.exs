defmodule AdvancedAwesomeWeb.LibrariesControllerTest do
  use AdvancedAwesomeWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    html_response(conn, 200) |> IO.inspect()
  end
end
