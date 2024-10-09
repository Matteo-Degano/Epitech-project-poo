defmodule ApiWeb.WorkingtimeController do
  use ApiWeb, :controller

  alias Api.Workingtimes
  alias Api.Workingtimes.Workingtime

  # GET (ALL) - Fetch working time entries for a user with optional start/end params
  def index(conn, %{"userID" => user_id} = params) do
    start_date = Map.get(params, "start")
    end_date = Map.get(params, "end")
    workingtimes = Workingtimes.list_workingtimes_by_user(user_id, start_date, end_date)
    render(conn, "index.json", workingtimes: workingtimes)
  end

  # GET (ONE) - Fetch a single working time entry by user and id
  def show(conn, %{"userID" => user_id, "id" => id}) do
    case Workingtimes.get_workingtime_by_user_and_id(user_id, id) do
      nil -> send_resp(conn, :not_found, "Working time not found")
      workingtime -> render(conn, "show.json", workingtime: workingtime)
    end
  end

  # POST - Create a new working time entry for a user
  def create(conn, %{"userID" => user_id, "workingtime" => workingtime_params}) do
    case Workingtimes.create_workingtime(user_id, workingtime_params) do
      {:ok, workingtime} ->
        conn
        |> put_status(:created)
        |> render("show.json", workingtime: workingtime)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ApiWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  # PUT - Update a working time entry
  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Workingtimes.get_workingtime!(id)

    case Workingtimes.update_workingtime(workingtime, workingtime_params) do
      {:ok, workingtime} ->
        render(conn, "show.json", workingtime: workingtime)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ApiWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  # DELETE - Delete a working time entry
  def delete(conn, %{"id" => id}) do
    workingtime = Workingtimes.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Workingtimes.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end
end