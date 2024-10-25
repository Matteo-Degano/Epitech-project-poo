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
          chart_4_data = calc_chart_4(workingtimes)

          response = %{
            start_date: DateTime.to_iso8601(start_date),
            end_date: DateTime.to_iso8601(end_date),
            total_days: Date.diff(end_date, start_date),
            chart_1: chart_1_data,
            chart_2: chart_2_data,
            chart_3: chart_3_data,
            chart_4: chart_4_data
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

  # Permet de retourner que le temps supplémentaire de travail (au delà de 8h) en secondes
  def calc_chart_4(workingtimes) do

    all_times_worked = Enum.map(workingtimes, fn(workingtime) ->

      start_time = ensure_naive_datetime(workingtime.start)
      end_time = ensure_naive_datetime(workingtime.end)

      total_seconds = NaiveDateTime.diff(end_time, start_time)

      major_total_seconds = if total_seconds > 8 * 3600 do
        total_seconds - (8 * 3600)
      else
        0
      end

      %{date: start_time, value: major_total_seconds}

    end)

    %{
      description: "Temps travaillé par jour majoré de 25% en secondes",
      data: all_times_worked
    }

  end

  defp seconds_to_time(total_seconds) do
    hours = div(total_seconds, 3600)
    minutes = div(rem(total_seconds, 3600), 60)
    seconds = rem(total_seconds, 60)
    {hours, minutes, seconds}
  end


  # Calculer le temps travaillé de nuit en secondes (horaires comptées de 21h à 6h)
  def calc_chart_3(workingtimes) do
    data = Enum.map(workingtimes, fn workingtime ->

      start_time = ensure_naive_datetime(workingtime.start)
      end_time = ensure_naive_datetime(workingtime.end)

      night_start_time = NaiveDateTime.new(start_time.year, start_time.month, start_time.day, 21, 0, 0) |> elem(1)
      night_end_time =
        case NaiveDateTime.new(start_time.year, start_time.month, start_time.day + 1, 6, 0, 0) do
          {:ok, dt} -> dt
          {:error, _} ->
            next_day = Date.add(Date.new!(start_time.year, start_time.month, start_time.day), 1)
            NaiveDateTime.new!(next_day.year, next_day.month, next_day.day, 6, 0, 0)
      end

      adjusted_start_time =
        if NaiveDateTime.compare(start_time, night_start_time) == :lt do
          night_start_time
        else
          start_time
        end

      adjusted_end_time =
        if NaiveDateTime.compare(end_time, night_end_time) == :gt do
          night_end_time
        else
          end_time
        end


      total_night_seconds =
        if NaiveDateTime.compare(adjusted_start_time, adjusted_end_time) == :lt do
          NaiveDateTime.diff(adjusted_end_time, adjusted_start_time)
        else
          0
        end

      %{start_date: start_time, end_date: end_time, total_night_seconds: total_night_seconds}

    end)

    %{
      description: "Temps travaillé de nuit en secondes (horaires comptées de 21h à 6h)",
      data: data
    }

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
      data: data,
      description: "Ratio de présence de l'employé"
    }

  end

end
