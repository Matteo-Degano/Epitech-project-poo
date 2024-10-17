defmodule ApiWeb.Util do
  import Plug.Conn
  import Jason, only: [encode!: 1]

  def json(conn, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, encode!(data))
  end
end
