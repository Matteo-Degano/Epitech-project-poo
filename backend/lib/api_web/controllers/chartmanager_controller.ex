defmodule ApiWeb.ChartManagerController do
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Workingtimes

  # ALL ROUTES WILL BY DEFAULT GET ALL THE STATS FROM THE LAST MONTH

  def show(conn, %{"userID" => userID}) do

    case Users.get_user!(userID) do
      nil ->
        conn
        |> put_status(:notfound)
        |> json(%{error: "Utilisateur non trouvé"})
      user ->
        workingtime = Workingtimes.get_workingtime!(user.id)
        # IO.puts("Workingtime: #{workingtime}")
        conn
        |> put_status(:ok)
        |> json(%{userid: user.id, username: user.username})


    end

  end

end
