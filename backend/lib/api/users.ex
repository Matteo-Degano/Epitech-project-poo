defmodule Api.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users() do
    Repo.all(User)
  end

  @doc """
  Returns the list of users by username and email.

  ## Examples

      iex> list_users_by_username_and_email("johndoe", "john@example.com")
      [%User{}, ...]

  """
  def list_users_by_username_and_email(username, email) do
    Repo.all(
      from(u in User,
        where: u.username == ^username and u.email == ^email
      )
    )
  end

  @doc """
  Returns the list of users managed by a specific manager.

  ## Examples

      iex> list_users_by_manager(1)
      [%User{}, ...]

  """
  def list_users_by_manager(manager_id) do
    Repo.all(
      from(u in User,
        where: u.manager_id == ^manager_id
      )
    )
  end

  @doc """
  Returns the list of users by team.

  ## Examples

      iex> list_users_by_team("team_a")
      [%User{}, ...]

  """
  def list_users_by_team(team) do
    Repo.all(
      from(u in User,
        where: u.team == ^team
      )
    )
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
