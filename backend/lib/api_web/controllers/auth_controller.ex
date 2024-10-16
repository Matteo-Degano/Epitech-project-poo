defmodule ApiWeb.AuthController do
  use ApiWeb, :controller

  alias Api.{Users, Users.Guardian}

  def login(conn, %{"email" => email, "password" => password}) do
    Users.authenticate_user(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    {:ok, access_token, _claims} =
      Guardian.encode_and_sign(user, %{role: user.role},
        ttl: {8, :hours},
        token_type: "access"
      )

    {:ok, refresh_token, _claims} =
      Guardian.encode_and_sign(user, %{},
        ttl: {7, :days},
        token_type: "refresh"
      )

    conn
    |> put_status(200)
    |> put_resp_cookie("access_token", access_token,
      http_only: true,
      # secure: true,
      max_age: 8 * 60 * 60
    )
    |> put_resp_cookie("refresh_token", refresh_token,
      http_only: true,
      # secure: true,
      same_site: "Strict",
      max_age: 7 * 24 * 60 * 60
    )
    |> json(%{message: "Authenticated successfully."})
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_status(401)
    |> json(%{error: reason})
  end
end
