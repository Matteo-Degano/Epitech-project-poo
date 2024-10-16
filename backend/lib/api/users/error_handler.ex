defmodule Api.Users.ErrorHandler do
  import Plug.Conn

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    _body = to_string(type)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, "Type: #{to_string(type)} \nReason:  #{to_string(reason)}")
  end
end
