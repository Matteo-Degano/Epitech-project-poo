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

        IO.inspect(workingtimes)

        pie_chart_data = calc_pie(start_date, end_date, workingtimes)

        conn
        |> put_status(:ok)
        |> json(%{pie_chart: pie_chart_data})

    end

  end

  # Différente manière de calculer la présence de l'employé sur un mois :
  # Passer toutes les dates une par une dans une fonction qui détermine si oui ou non l'employé était présent pour le jour correspondant à la date,
  # puis additionner le nombre de jours où l'employé était présent et diviser par le nombre de jours dans le mois, SAUF qu'en faisant ça
  # on part du principe qu'il n'atteindra jamais 100% de présence car il y a des jours où il ne travaille pas tels que les week-endet les jours fériés.
  # donc il faudrait récupérer via une api les jours fériés et les week-end pour les soustraire du nombre de jours dans le mois.
  # et bah, y'a du taff, mais c'est faisable.

  def calc_pie(start_date, end_date, workingtimes) do

    all_dates = Enum.map(0..Date.diff(end_date, start_date), fn n ->
      Date.add(start_date, n)
    end)

    worked_dates = workingtimes |> Enum.map(fn %{start: start_time} ->
        NaiveDateTime.to_date(start_time)
      end) |> Enum.uniq()

    days_worked = Enum.filter(all_dates, fn date ->
      date in worked_dates
    end)

    %{
      days_worked: length(days_worked),
      days_not_worked: length(all_dates) - length(days_worked)
    }

  end



  def has_worked_on_day(date) do
    IO.puts("HAS WORKED ON DAY")
    IO.inspect(date)
  end

end
