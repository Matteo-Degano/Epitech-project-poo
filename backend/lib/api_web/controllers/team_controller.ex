defmodule ApiWeb.TeamController do
  use ApiWeb, :controller

  alias Api.Teams
  alias Api.Teams.Team
  alias Api.Users
  alias Api.Users.Guardian
  alias Api.Plug.CheckCookie
  alias Api.Roles
  alias Api.Repo
  alias Api.Workingtimes

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"name" => name_params}) do

    params = %{
      "name" => name_params
    }

    with {:ok, %Team{} = team} <- Teams.create_team(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "name" => name_params}) do

    team_params = %{
      "name" => name_params
    }

    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    if Api.Users.team_has_users?(team.id) do
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Cannot delete team with associated users"})
    else
      with {:ok, %Team{}} <- Teams.delete_team(team) do
        send_resp(conn, :no_content, "")
      end
    end
  end

  def workingtimes(conn, _params) do
    {_, token} = CheckCookie.get_tokens(conn)

    case Guardian.decode_and_verify(token) do
      {:ok, token_data} ->
        user_id = token_data["sub"]
        current_user = Users.get_user!(user_id) |> Repo.preload(:teams)

        role = Roles.get_role!(current_user.role_id)
        IO.inspect(role.name, label: "role")

        if role.name == "manager" or role.name == "admin" or role.name == "general_manager" do
          team_ids = Enum.map(current_user.teams, & &1.id)
          IO.inspect(team_ids, label: "team_ids")

          working_times_by_team =
            Enum.map(team_ids, fn team_id ->
              working_times = Workingtimes.list_workingtimes_by_teams(%{teams: [team_id]})

              %{
                team_id: team_id,
                working_times: working_times
              }
            end)

          json(conn, working_times_by_team)
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "Access forbidden: only managers can access this resource"})
        end

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid token"})
    end
  end




end
