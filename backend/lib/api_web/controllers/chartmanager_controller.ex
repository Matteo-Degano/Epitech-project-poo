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

          chart_1_data = calc_chart_1(start_date, end_date, workingtimes)
          chart_2_data = calc_chart_2(workingtimes)

          chart_3_data = calc_chart_3(workingtimes)

          response = %{
            start_date: DateTime.to_iso8601(start_date),
            end_date: DateTime.to_iso8601(end_date),
            total_days: Date.diff(end_date, start_date),
            # chart_3: chart_3_data,
            # chart_1: chart_1_data,
            # chart_2: chart_2_data
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


  def calc_chart_3(workingtimes) do
    data = Enum.map(workingtimes, fn workingtime ->

      start_time = ensure_naive_datetime(workingtime.start)
      end_time = ensure_naive_datetime(workingtime.end)

      night_start_time = NaiveDateTime.new(start_time.year, start_time.month, start_time.day, 21, 0, 0) |> elem(1)
      night_end_time = NaiveDateTime.new(start_time.year, start_time.month, start_time.day + 1, 6, 0, 0) |> elem(1) # 6h du jour suivant

      IO.inspect(start_time)
      IO.inspect(end_time)

      IO.inspect(night_start_time)
      IO.inspect(night_end_time)

      adjusted_start_time =
        if NaiveDateTime.compare(start_time, night_start_time) == :lt do
          night_start_time
        else
          start_time
        end

      IO.inspect("adjusted_start_time #{adjusted_start_time}")

      adjusted_end_time =
        if NaiveDateTime.compare(end_time, night_end_time) == :gt do
          night_end_time
        else
          end_time
        end

      IO.inspect("adjusted_end_time #{adjusted_end_time}")

      total_night_seconds =
        if NaiveDateTime.compare(adjusted_start_time, adjusted_end_time) == :lt do
          NaiveDateTime.diff(adjusted_end_time, adjusted_start_time)
        else
          0
        end

      IO.inspect(("total_night_seconds #{total_night_seconds}"))

    end)
  end

  defp ensure_naive_datetime(datetime) do
    case datetime do
      %NaiveDateTime{} -> datetime
      %DateTime{} -> DateTime.to_naive(datetime)
      _ -> raise "Unsupported datetime format"
    end
  end


  # Calcule le temps travaillé par jour en secondes pour chaque jour de la période
  def calc_chart_2(workingtimes) do

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
  def calc_chart_1(start_date, end_date, workingtimes) do

    all_dates = Enum.map(0..Date.diff(end_date, start_date), fn n ->
      Date.add(start_date, n)
    end)

    weekends = Enum.filter(all_dates, fn date ->
      day_of_week = Date.day_of_week(date)
      day_of_week == 6 or day_of_week == 7
    end)

    worked_dates = workingtimes |> Enum.map(fn %{start: start_time} ->
        NaiveDateTime.to_date(start_time)
      end) |> Enum.uniq()

    days_worked = Enum.filter(all_dates, fn date ->
      date in worked_dates and not (date in weekends)
    end)

    data = [
      %{
        name: "Jours travaillés",
        value: length(days_worked)
      },
      %{
        name: "Jours non travaillés",
        value: length(all_dates) - length(days_worked) - length(weekends)
      },
      %{
        name: "Ratio",
        value: ((length(days_worked) / (length(all_dates) - length(weekends))) * 100) |> Float.ceil(2)
      }
    ]

    %{
      data: data
    }

  end

end
