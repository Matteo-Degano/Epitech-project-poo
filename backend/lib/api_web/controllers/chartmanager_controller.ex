defmodule ApiWeb.ChartManagerController do
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Workingtimes

  # ALL ROUTES WILL BY DEFAULT GET ALL THE STATS FROM THE LAST MONTH

  def show(conn, %{"userID" => userID}) do


    time_jump = 3
    start_date = DateTime.utc_now() |> DateTime.add(-30 + time_jump, :day)
    end_date = DateTime.utc_now() |> DateTime.add(time_jump, :day)

    case Users.get_user!(userID) do
      nil ->
        conn
        |> put_status(:notfound)
        |> json(%{error: "Utilisateur non trouvé"})
      user ->

        workingtime_params = %{
          "user_id" => user.id,
          "start" => DateTime.to_iso8601(start_date),
          "end" => DateTime.to_iso8601(end_date)
        }

        workingtimes = Workingtimes.list_workingtimes_by_start_and_end(workingtime_params)
        calc_pie(workingtimes)

        conn
        |> put_status(:ok)
        |> json(%{workingtimes: workingtimes})

    end

  end

  # Différente manière de calculer la présence de l'employé sur un mois :
  # Passer toutes les dates une par une dans une fonction qui détermine si oui ou non l'employé était présent pour le jour correspondant à la date,
  # puis additionner le nombre de jours où l'employé était présent et diviser par le nombre de jours dans le mois, SAUF qu'en faisant ça
  # on part du principe qu'il n'atteindra jamais 100% de présence car il y a des jours où il ne travaille pas tels que les week-end.
  # donc il faudrait récupérer via une api les jours fériés et les week-end pour les soustraire du nombre de jours dans le mois.
  # et bah, y'a du taff, mais c'est faisable.

  def calc_pie(workingtimes) do

    workingtimes_lenght = length(workingtimes)

    Enum.each(1..workingtimes_lenght, fn(_x) ->
      has_worked_on_day(Enum.at(workingtimes, 1))
    end)

  end

  def has_worked_on_day(date) do
    IO.puts("HAS WORKED ON DAY")
    IO.inspect(date)
  end

end
