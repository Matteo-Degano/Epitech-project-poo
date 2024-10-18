defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.{Users, Users.User}
  alias Api.Repo

  action_fallback(ApiWeb.FallbackController)

  def index(conn, %{"username" => username, "email" => email}) do
    users = Users.list_users_by_username_and_email(username, email)
    render(conn, :index, users: users)
  end

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{
    "username" => username,
    "email" => email,
    "password" => password,
    "role_id" => role_id,
    "team_ids" => team_ids
  }) do
    user_params = %{
      "username" => username,
      "email" => email,
      "password" => password,
      "role_id" => role_id,
      "team_ids" => team_ids
    }

    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end


  def show(conn, %{"id" => id}) do
    case Users.get_user_with_teams(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        teams = Enum.map(user.teams, fn team -> %{id: team.id, name: team.name} end)

        response = %{
          id: user.id,
          username: user.username,
          email: user.email,
          role_id: user.role_id,
          teams: teams
        }

        conn
        |> put_status(:ok)
        |> json(response)
    end
  end


  def update(conn, %{"id" => id} = params) do
    user = Users.get_user!(id)

    user_params =
      params
      |> Enum.filter(fn {key, _value} -> key in ["username", "email", "role_id"] end)
      |> Enum.into(%{})

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
