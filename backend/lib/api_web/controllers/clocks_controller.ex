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
  def create(conn, %{"time" => time}) do
    clocks_params = %{"user" => conn.params["user"], "status" => true, "time" => time}

    with {:ok, %Clocks{} = clocks} <- Clocking.create_clocks(clocks_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clocks}")
      |> render(:show, clocks: clocks)
    end
  end

  # Get clockings by user
  def show(conn, %{"user" => user}) do
    clocks = Clocking.get_clocks_by_user(user)
    render(conn, :index, clocks: clocks)
  end
end
