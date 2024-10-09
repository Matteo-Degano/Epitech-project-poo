defmodule ApiWeb.ClocksController do
  require Logger
  use ApiWeb, :controller

  alias Api.Clocking
  alias Api.Clocking.Clocks

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    clocks = Clocking.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"status" => status, "time" => time}) do
    clocks_params = %{"user" => conn.params["user"], "status" => status, "time" => time}

    with {:ok, %Clocks{} = clocks} <- Clocking.create_clocks(clocks_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clocks}")
      |> render(:show, clocks: clocks)
    end
  end

  def show(conn, %{"user" => user}) do
    clocks = Clocking.get_clocks!(user)
  end
end
