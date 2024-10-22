defmodule Api.Workingtimes do
  import Ecto.Query, warn: false

  alias Api.Repo

  alias Api.Users.User
  alias Api.Workingtimes.Workingtime
  alias Api.UsersTeams

  def list_workingtimes() do
    Repo.all(Workingtime)
  end

  def list_workingtimes_by_user(user_id) do
    query = from(w in Workingtime, where: w.user_id == ^user_id)
    Repo.all(query)
  end

  def list_workingtimes_by_start_and_end(%{
        "user_id" => user_id,
        "start" => start_params,
        "end" => end_params
      }) do
    {:ok, start_time} = NaiveDateTime.from_iso8601(start_params)
    {:ok, end_time} = NaiveDateTime.from_iso8601(end_params)

    query =
      from(w in Workingtime,
        where: w.start >= ^start_time and w.end <= ^end_time and w.user_id == ^user_id
      )

    Repo.all(query)
  end

  def list_workingtimes_by_teams(attrs \\ %{}) do
    user_query =
      if attrs do
        team_query = from(t in UsersTeams, where: t.team_id in ^attrs.teams, select: t.user_id)

        from(u in User,
          where: u.id in subquery(team_query)
        )
      else
        from(u in User)
      end

    users = Repo.all(user_query)
    user_ids = Enum.map(users, fn u -> u.id end)

    workingtime_query =
      from(w in Workingtime,
        where: w.user_id in ^user_ids
      )

    workingtimes = Repo.all(workingtime_query)

    Enum.map(workingtimes, fn w ->
      %{
        id: w.id,
        start: w.start,
        end: w.end,
        inserted_at: w.inserted_at,
        updated_at: w.updated_at,
        user: find__and_format_user(users, w.user_id)
      }
    end)
  end

  def get_workingtime!(id) do
    Repo.get!(Workingtime, id)
  end

  def get_workingtime_by_user!(%{"id" => id, "user_id" => user_id}) do
    Repo.get_by!(Workingtime, id: id, user_id: user_id)
  end

  def create_workingtime(attrs \\ %{}) do
    %Workingtime{}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end

  def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
    Workingtime.changeset(workingtime, attrs)
  end

  defp find__and_format_user(users, id) do
    user = Enum.find(users, fn u -> id == u.id end)

    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
