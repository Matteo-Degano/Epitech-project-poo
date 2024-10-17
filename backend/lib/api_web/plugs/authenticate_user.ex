defmodule ApiWeb.Plugs.AuthenticateUser do
  import Plug.Conn
  alias ApiWeb.Util
  alias Api.Users
  alias JOSE.JWT

  @secret_key Application.compile_env(:api, ApiWeb.Endpoint)[:secret_key_base]

  def init(default), do: default

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {_, claims} <- JWT.verify(token, @secret_key),
         %{"id" => user_id} <- claims do
      user = Users.get_user!(user_id)
      assign(conn, :current_user, user)
    else
      _ ->
        conn
        |> put_status(:unauthorized)
        |> Util.json(%{error: "Unauthorized"})
        |> halt()
    end
  end
end
