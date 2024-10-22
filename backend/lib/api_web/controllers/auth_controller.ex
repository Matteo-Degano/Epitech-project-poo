defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  alias Api.{Users, Users.Guardian}

  def refresh(conn, _params) do
    refresh_token = Map.get(conn.cookies, "refresh_token")

    Guardian.decode_and_verify(refresh_token, %{"typ" => "refresh"})
    |> refresh_reply(conn)
  end

  defp refresh_reply({:ok, claims}, conn) do
    user = Users.get_user!(claims["sub"])

    {:ok, access_token, _claims} =
      Guardian.encode_and_sign(user, %{role: user.role_id},
        ttl: {8, :hours},
        token_type: "access"
      )

    conn
    |> put_resp_cookie("access_token", access_token,
      # secure: true,
      max_age: 8 * 60 * 60
    )
    |> put_status(200)
    |> json(%{message: "Tokens refreshed."})
  end

  defp refresh_reply({:error, reason}, conn) do
    conn
    |> put_status(400)
    |> json(%{error: reason})
  end

  def logout(conn, _params) do
    conn
    |> put_resp_cookie("access_token", "", max_age: 0)
    |> put_resp_cookie("refresh_token", "", max_age: 0)
    |> put_status(200)
    |> json(%{message: "Cookies removed."})
  end

  def login(conn, %{"email" => email, "password" => password}) do
    Users.authenticate_user(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    teams = Enum.map(user.teams, fn team -> %{id: team.id, name: team.name} end)

    {:ok, access_token, _claims} =
      Guardian.encode_and_sign(user, %{role: user.role_id, team: teams},
        ttl: {8, :hours},
        token_type: "access"
      )

    {:ok, refresh_token, _claims} =
      Guardian.encode_and_sign(user, %{},
        ttl: {7, :days},
        token_type: "refresh"
      )

    response = %{
      id: user.id,
      username: user.username,
      email: user.email,
      role_id: user.role_id,
      teams: teams
    }

    conn
    |> put_status(200)
    |> put_resp_cookie("access_token", access_token,
      secure: true,
      max_age: 8 * 60 * 60
    )
    |> put_resp_cookie("refresh_token", refresh_token,
      secure: true,
      # same_site: "Strict",
      max_age: 7 * 24 * 60 * 60
    )
    |> json(response)
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_status(400)
    |> json(%{error: reason})
  end
end
