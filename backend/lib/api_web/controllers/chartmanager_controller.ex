defmodule ApiWeb.ChartManagerController do
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Workingtimes

  # /!\ TOUS LES GRAPHIQUES ONT DES DATES DEBUT ET FIN DE 30 JOURS A PARTIR DE L'APPEL API PAR DEFAUT /!\

  def show(conn, %{"userID" => userID, "start" => start_date_str, "end" => end_date_str}) do

    with {:ok, start_date, _} <- DateTime.from_iso8601(start_date_str),
         {:ok, end_date, _} <- DateTime.from_iso8601(end_date_str) do

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

          donut_chart_data = calc_donut_chart(start_date, end_date, workingtimes)
          line_chart_data = calc_line_chart(workingtimes)

          response = %{
            start_date: DateTime.to_iso8601(start_date),
            end_date: DateTime.to_iso8601(end_date),
            total_days: Date.diff(end_date, start_date),
            donut_chart: donut_chart_data,
            line_chart: line_chart_data
          }

          conn
          |> put_status(:ok)
          |> json(response)
      end
    else
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Les dates doivent être au format ISO8601."})
    end
  end

  def show(conn, %{"userID" => userID}) do

    start_date = DateTime.utc_now() |> DateTime.add(-30, :day)
    end_date = DateTime.utc_now()
    show(conn, %{"userID" => userID, "start" => DateTime.to_iso8601(start_date), "end" => DateTime.to_iso8601(end_date)})

  end

  # Calcule le temps travaillé par jour en secondes pour chaque jour de la période
  def calc_line_chart(workingtimes) do

    # On récupère la différence entre la date de début et la date de fin de travail pour en extarire les secones
    all_times_worked = Enum.map(workingtimes, fn(workingtime) ->

      day = NaiveDateTime.to_date(workingtime.start)

      time_worked_in_seconds = NaiveDateTime.diff(workingtime.end, workingtime.start)

      %{day: day, time_worked: time_worked_in_seconds}

    end)

    %{
      description: "Temps travaillé par jour en secondes",
      data: all_times_worked
    }

  end


  # TODO: Implémenter la récupération des jours fériés pour améliorer la précision du calcul du ratio de présence de l'employé
  def calc_donut_chart(start_date, end_date, workingtimes) do

    # Ici c'est toutes les dates entre start_date et end_date
    all_dates = Enum.map(0..Date.diff(end_date, start_date), fn n ->
      Date.add(start_date, n)
    end)

    # Ensuite on choppe les week-ends qui sont, d'après la fonction day_of_week, l'index 6 et 7
    weekends = Enum.filter(all_dates, fn date ->
      day_of_week = Date.day_of_week(date)
      day_of_week == 6 or day_of_week == 7
    end)

    # Puis on choppe les jours où l'employé a travaillé
    worked_dates = workingtimes |> Enum.map(fn %{start: start_time} ->
        NaiveDateTime.to_date(start_time)
      end) |> Enum.uniq()

    # On filtre les jours travaillés pour garder que ceux qui ne sont pas des week-ends
    days_worked = Enum.filter(all_dates, fn date ->
      date in worked_dates and not (date in weekends)
    end)

    %{
      days_worked: %{
        name: "Jours travaillés",
        description: "Correspond au nombre de jours où l'employé a travaillé",
        value: length(days_worked)
      },
      days_not_worked: %{
        name: "Jours non travaillés",
        description: "Correspond au nombre de jours où l'employé n'a pas travaillé ou a été absent (week-ends non inclus)",
        value: length(all_dates) - length(days_worked) - length(weekends)
      },
      ratio: %{
        name: "Ratio",
        description: "Pourcentage de jours travaillés par rapport au nombre total de jours dans la période",
        value: ((length(days_worked) / (length(all_dates) - length(weekends))) * 100) |> Float.ceil(2)
      }
    }

  end

end
