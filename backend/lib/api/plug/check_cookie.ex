defmodule Api.Plug.CheckCookie do
  import Plug.Conn

  alias Api.Users.Guardian

  def init(opts), do: opts

  def call(conn, _opts) do
    {refresh_token, access_token} = get_tokens(conn)

    conn
    |> validate_token(refresh_token, "refresh")
    |> validate_token(access_token, "access")
  end

  def get_tokens(conn) do
    cookies = conn.cookies
    refresh_token = Map.get(cookies, "refresh_token")
    access_token = Map.get(cookies, "access_token")

    {refresh_token, access_token}
  end

  defp validate_token(conn, token, typ) do
    Guardian.decode_and_verify(token, %{"typ" => typ})
    |> call_reply(conn)
  end

  defp call_reply({:ok, _claims}, conn) do
    conn
  end

  defp call_reply({:error, _reason}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, "\{\n  \"error\": \"Unauthorized\"\n\}")
  end
end
