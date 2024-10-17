defmodule ApiWeb.Plugs.AuthorizeRole do
  import Plug.Conn
  import Phoenix.Controller

  alias ApiWeb.ErrorView

  def init(default), do: default

  def call(conn, role) do
    if authorized?(conn, role) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> put_view(ErrorView)
      |> render("403.json", message: "Forbidden")
      |> halt()
    end
  end

  defp authorized?(conn, role) do
    user_role = get_user_role(conn)
    user_role == role
  end

  defp get_user_role(conn) do
    get_session(conn, :user_role) || :guest
  end
end
