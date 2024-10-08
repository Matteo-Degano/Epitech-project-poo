defmodule ApiWeb.ClocksController do
  use ApiWeb, :controller

  alias Api.Clocking
  alias Api.Clocking.Clocks

  action_fallback ApiWeb.FallbackController

  def index(conn, _params) do
    clocks = Clocking.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"userId" => user, "clocks" => clocks_params}) do
    with {:ok, %Clocks{} = clocks} <- Clocking.create_clocks(clocks_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clocks}")
      |> render(:show, clocks: clocks)
    end
  end

  def show(conn, %{"userId" => user}) do
    clocks = Clocking.get_clocks!(id)
    render(conn, :show, clocks: clocks)
  end
end
