defmodule Api.Plug.AuthorizeRole do
  import Plug.Conn

  alias Api.Roles
  alias Api.Users.Guardian
  alias Api.Plug.CheckCookie

  def init(opts), do: opts

  def call(conn, opts) do
    role = get_role(conn)

    IO.inspect(is_authorized(role, opts), label: "is_authorized")

    case is_authorized(role, opts) do
      :ok ->
        conn

      :error ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(403, "\{\n  \"error\": \"Forbidden\"\n\}")
    end
  end

  defp get_role(conn) do
    {_, token} = CheckCookie.get_tokens(conn)
    {:ok, token_data} = Guardian.decode_and_verify(token)
    Roles.get_role!(token_data["role"])
  end

  defp is_authorized(role, opts) do
    case opts do
      "admin" -> check_admin(role)
      "general_manager" -> check_general_manager(role)
      "manager" -> check_manager(role)
      "user" -> :ok
      _ -> :error
    end
  end

  defp check_admin(role) do
    if role != "admin" do
      :error
    else
      :ok
    end
  end

  defp check_general_manager(role) do
    if role != "general_manager" && role != "admin" do
      :error
    else
      :ok
    end
  end

  defp check_manager(role) do
    if role != "manager" && role != "general_manager" && role != "admin" do
      :error
    else
      :ok
    end
  end
end
