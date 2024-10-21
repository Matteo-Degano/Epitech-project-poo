defmodule Api.Workingtimes do
  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Workingtimes.Workingtime

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
end
