defmodule ApiWeb.WorkingtimeController do
  use ApiWeb, :controller

  alias Api.{Workingtimes, Workingtimes.Workingtime}
  alias Api.Users

  action_fallback(ApiWeb.FallbackController)

  def index(conn, %{"user" => user_id, "start" => start_params, "end" => end_params}) do
    workingtime_params = %{
      "user_id" => user_id,
      "start" => start_params,
      "end" => end_params
    }

    workingtimes = Workingtimes.list_workingtimes_by_start_and_end(workingtime_params)

    conn
    |> put_status(200)
    |> json(workingtimes)
  end

  def index(conn, %{"user" => user_id}) do
    workingtimes = Workingtimes.list_workingtimes_by_user(user_id)

    conn
    |> put_status(200)
    |> json(workingtimes)
  end

  def create(conn, %{"user" => user_id_params, "start" => start_params, "end" => end_params}) do
    workingtime_params = %{
      "start" => start_params,
      "end" => end_params,
      "user_id" => user_id_params
    }

    with {:ok, %Workingtime{} = workingtime} <-
           Workingtimes.create_workingtime(workingtime_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{workingtime}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, _) do
    {:ok, user} = Users.get_current_user(conn)
    teams = Enum.map(user.teams, fn t -> t.id end)

    workingtimes =
      case user.role.name do
        "user" ->
          Workingtimes.list_workingtimes_by_user(user.id)

        "manager" ->
          Workingtimes.list_workingtimes_by_teams(%{teams: teams})

        "general_manager" ->
          Workingtimes.list_workingtimes_by_teams(nil)

        "admin" ->
          Workingtimes.list_workingtimes_by_teams(nil)
      end

    conn
    |> put_status(200)
    |> json(workingtimes)
  end

  def show_user_workingtime(conn, %{"id" => id, "user" => user_id}) do
    workingtime_params = %{
      "id" => id,
      "user_id" => user_id
    }

    workingtime = Workingtimes.get_workingtime_by_user!(workingtime_params)
    render(conn, :show, workingtime: workingtime)
  end

  def update(conn, %{"id" => id, "start" => start_params, "end" => end_params}) do
    workingtime_params = %{
      "id" => id,
      "start" => start_params,
      "end" => end_params
    }

    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <-
           Workingtimes.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end
