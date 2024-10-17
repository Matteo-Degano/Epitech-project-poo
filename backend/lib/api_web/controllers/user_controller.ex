defmodule ApiWeb.UserController do
  use ApiWeb, :controller

  alias Api.{Users, Users.User, Teams, TeamsUsers}
  alias Api.{Repo, Changeset}
  alias Ecto.Changeset
  alias Ecto.Query

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

      current_time = DateTime.utc_now() |> DateTime.truncate(:second)
      teams_data = Enum.map(team_ids, fn team_id ->
            %{
              user_id: user.id,
              team_id: team_id,
              inserted_at: current_time,
              updated_at: current_time
            }
          end)

      Repo.insert_all("teams_users", teams_data)

      conn
      |> put_status(:created)
      |> render(:show, user: user)
    end

  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    teams = Users.list_users_teams(id)

    response = %{
      user: user,
      teams: teams
    }

    IO.inspect(teams)
    render(conn, :show, response)
  end

  def update(conn, %{"id" => id} = params) do
    user = Users.get_user!(id)

    user_params =
      params
      |> Enum.filter(fn {key, _value} -> key in ["username", "email", "role_id", "team_ids"] end)
      |> Enum.into(%{})

    with {:ok, %User{} = user} <- Users.update_user(user, user_params) do

      # Repo.delete_all(from tu in "teams_users", where: tu.user.id == ^id)
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
