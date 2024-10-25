defmodule ApiWeb.ClocksController do
  require Logger
  use ApiWeb, :controller

  alias Api.Workingtimes.Workingtime
  alias Api.Workingtimes
  alias Api.{Clocks, Clocks.Clock}

  action_fallback(ApiWeb.FallbackController)

  # List all clocks
  def index(conn, _params) do
    clocks = Clocks.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  # Create a clock entry
  def create(conn, %{"time" => time, "status" => status}) do
    user_clock = Clocks.has_active_clock(conn.params["user"])

    {status, response} =
      cond do
        !user_clock ->
          clocks_params = %{"user_id" => conn.params["user"], "status" => status, "time" => time}

          with {:ok, %Clock{} = clocks} <- Clocks.create_clocks(clocks_params) do
            put_resp_header(conn, "location", ~p"/api/clocks/#{clocks}")
            {201, format_clock_json(clocks)}
          end

        user_clock && status == true ->
          {200, %{message: "A clock is already active."}}

        user_clock && status == false ->
          workingtime_params = %{
            user_id: conn.params["user"],
            start: user_clock.time,
            end: NaiveDateTime.utc_now()
          }

          Clocks.update_clocks(user_clock, %{status: false})

          with {:ok, %Workingtime{} = workingtime} <-
                 Workingtimes.create_workingtime(workingtime_params) do
            put_resp_header(conn, "location", ~p"/api/workingtime/#{workingtime}")

            {201,
             %{
               message: "Clock updated and corresponding Workingtime created.",
               workingtime: workingtime
             }}
          end
      end

    IO.inspect(status, label: "clock status")
    IO.inspect(response, label: "clock response")

    conn
    |> put_status(status)
    |> json(response)
  end

  # Get clocks by user
  def show(conn, %{"user" => user}) do
    case clocks = Clocks.get_clocks_by_user(user) do
      [] -> send_resp(conn, :not_found, "No clockings found for user")
      clocks -> render(conn, :index, clocks: clocks)
    end

    render(conn, :index, clocks: clocks)
  end

  defp format_clock_json(%Clock{} = clock) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status,
      user_id: clock.user_id,
      inserted_at: clock.inserted_at,
      updated_at: clock.updated_at
    }
  end
end
