defmodule Api.Users do
  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.Users.User
  alias Argon2

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

  def create_user(attrs \\ %{}) do
    %User{}
    |> Repo.preload(:role)
    |> Repo.preload(:team)
    |> User.changeset(attrs)
    |> Repo.insert()
  end
  
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, plain_text_password) do
    query = from(u in User, where: u.email == ^email)

    case Repo.one(query) do
      nil ->
        Argon2.no_user_verify()
        {:error, :invalid_credentials}

      user ->
        if Argon2.verify_pass(plain_text_password, user.password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
