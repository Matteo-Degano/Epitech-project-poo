# defmodule Api.Workingtimes do
#   @moduledoc """
#   The Workingtimes context.
#   """

#   import Ecto.Query, warn: false
#   alias Api.Repo

#   alias Api.Workingtimes.Workingtime

#   @doc """
#   Returns the list of workingtimes.

#   ## Examples

#       iex> list_workingtimes()
#       [%Workingtime{}, ...]

#   """
#   def list_workingtimes do
#     Repo.all(Workingtime)
#   end

#   @doc """
#   Gets a single workingtime.

#   Raises `Ecto.NoResultsError` if the Workingtime does not exist.

#   ## Examples

#       iex> get_workingtime!(123)
#       %Workingtime{}

#       iex> get_workingtime!(456)
#       ** (Ecto.NoResultsError)

#   """
#   def get_workingtime!(id), do: Repo.get!(Workingtime, id)

#   @doc """
#   Creates a workingtime.

#   ## Examples

#       iex> create_workingtime(%{field: value})
#       {:ok, %Workingtime{}}

#       iex> create_workingtime(%{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def create_workingtime(attrs \\ %{}) do
#     %Workingtime{}
#     |> Workingtime.changeset(attrs)
#     |> Repo.insert()
#   end

#   @doc """
#   Updates a workingtime.

#   ## Examples

#       iex> update_workingtime(workingtime, %{field: new_value})
#       {:ok, %Workingtime{}}

#       iex> update_workingtime(workingtime, %{field: bad_value})
#       {:error, %Ecto.Changeset{}}

#   """
#   def update_workingtime(%Workingtime{} = workingtime, attrs) do
#     workingtime
#     |> Workingtime.changeset(attrs)
#     |> Repo.update()
#   end

#   @doc """
#   Deletes a workingtime.

#   ## Examples

#       iex> delete_workingtime(workingtime)
#       {:ok, %Workingtime{}}

#       iex> delete_workingtime(workingtime)
#       {:error, %Ecto.Changeset{}}

#   """
#   def delete_workingtime(%Workingtime{} = workingtime) do
#     Repo.delete(workingtime)
#   end

#   @doc """
#   Returns an `%Ecto.Changeset{}` for tracking workingtime changes.

#   ## Examples

#       iex> change_workingtime(workingtime)
#       %Ecto.Changeset{data: %Workingtime{}}

#   """
#   def change_workingtime(%Workingtime{} = workingtime, attrs \\ %{}) do
#     Workingtime.changeset(workingtime, attrs)
#   end
# end

defmodule Api.Workingtimes do
  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.Workingtimes.Workingtime

  def get_workingtime!(id), do: Repo.get!(Workingtime, id)
  
  # Get all working times for a user with optional start and end dates
  def list_workingtimes_by_user(user_id, start_date \\ nil, end_date \\ nil) do
    query =
      from w in Workingtime,
        where: w.user_id == ^user_id,
        where: is_nil(^start_date) or w.start >= ^start_date,
        where: is_nil(^end_date) or w.end <= ^end_date

    Repo.all(query)
  end

  # Get a specific working time by user and ID
  def get_workingtime_by_user_and_id(user_id, id) do
    Repo.get_by(Workingtime, user_id: user_id, id: id)
  end

  # Create a working time entry
  def create_workingtime(user_id, attrs \\ %{}) do
    %Workingtime{user_id: user_id}
    |> Workingtime.changeset(attrs)
    |> Repo.insert()
  end

  # Update a working time entry
  def update_workingtime(%Workingtime{} = workingtime, attrs) do
    workingtime
    |> Workingtime.changeset(attrs)
    |> Repo.update()
  end

  # Delete a working time entry
  def delete_workingtime(%Workingtime{} = workingtime) do
    Repo.delete(workingtime)
  end
end