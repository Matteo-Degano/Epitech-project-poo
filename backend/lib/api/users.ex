defmodule Api.Users do
  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.Teams.Team
  alias Api.Users.User
  alias Api.UsersTeams
  alias Argon2

  def list_users() do
    Repo.all(User)
  end

  def list_users_by_username_and_email(username, email) do
    Repo.all(
      from(u in User,
        where: u.username == ^username and u.email == ^email
      )
    )
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_with_teams(id) do
    Repo.get(User, id)
    |> Repo.preload(:teams)
  end

  def create_user(attrs \\ %{}) do
    team_ids = Map.get(attrs, "team_ids", [])

    changeset = %User{}
    |> User.changeset(Map.drop(attrs, ["team_ids"]))

    case Repo.insert(changeset) do
      {:ok, user} ->
        case associate_teams(user, team_ids) do
          :ok -> {:ok, user}
          {:error, reason} -> {:error, reason}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp associate_teams(user, team_ids) when is_list(team_ids) do
    Enum.each(team_ids, fn team_id ->
      users_team_changeset = UsersTeams.changeset(%UsersTeams{}, %{
        user_id: user.id,
        team_id: team_id
      })

      case Repo.insert(users_team_changeset) do
        {:ok, _} -> :ok
        {:error, changeset} -> {:error, changeset}
      end
    end)
  end

  defp associate_teams(_, _), do: :ok

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
