defmodule ApiWeb.ClocksController do
  require Logger
  use ApiWeb, :controller

  alias Api.Clocking
  alias Api.Clocking.Clocks

  action_fallback ApiWeb.FallbackController

  # List all clockings
  def index(conn, _params) do
    clocks = Clocking.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  # Create a clocking entry
  def create(conn, %{"time" => time, "status" => status}) do
    clocks_params = %{"user" => conn.params["user"], "status" => status, "time" => time}

    with {:ok, %Clocks{} = clocks} <- Clocking.create_clocks(clocks_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clocks}")
      |> render(:show, clocks: clocks)
    end
  end

  # Get clockings by user
  def show(conn, %{"user" => user}) do
    case clocks = Clocking.get_clocks_by_user(user) do
      [] -> send_resp(conn, :not_found, "No clockings found for user")
      clocks -> render(conn, :index, clocks: clocks)
    end
    render(conn, :index, clocks: clocks)
  end
end
