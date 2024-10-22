defmodule Api.Users do
  import Ecto.Query, warn: false
  alias Api.Repo
  alias Api.Users.{User, Guardian}
  alias Api.UsersTeams
  alias Argon2

  def list_users() do
    Repo.all(User)
  end

  def list_users_by_username_and_email_with_teams(username, email) do
    query = from(u in User, where: u.username == ^username and u.email == ^email)

    Repo.all(query)
    |> Repo.preload(:teams)
  end

  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:role)
    |> Repo.preload(:teams)
  end

  def get_user_with_teams(id) do
    Repo.get(User, id)
    |> Repo.preload(:teams)
  end

  def create_user(attrs \\ %{}) do
    team_ids = Map.get(attrs, "team_ids", [])

    changeset =
      %User{}
      |> User.changeset(Map.drop(attrs, ["team_ids"]))

    case Repo.insert(changeset) do
      {:ok, user} ->
        case associate_teams(user, team_ids) do
          :ok ->
            user_with_teams = Repo.preload(user, :teams)
            {:ok, user_with_teams}

          {:error, reason} ->
            {:error, reason}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp associate_teams(user, team_ids) when is_list(team_ids) do
    Enum.each(team_ids, fn team_id ->
      users_team_changeset =
        UsersTeams.changeset(%UsersTeams{}, %{
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
    team_ids = Map.get(attrs, "team_ids", nil)

    user_changeset =
      user
      |> User.changeset(Map.drop(attrs, ["team_ids"]))

    case Repo.update(user_changeset) do
      {:ok, updated_user} ->
        if team_ids != nil do
          Repo.delete_all(from(ut in Api.UsersTeams, where: ut.user_id == ^user.id))

          case associate_teams(updated_user, team_ids) do
            :ok ->
              user_with_teams = Repo.preload(updated_user, :teams)
              {:ok, user_with_teams}

            {:error, reason} ->
              {:error, reason}
          end
        else
          user_with_teams = Repo.preload(updated_user, :teams)
          {:ok, user_with_teams}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def authenticate_user(email, plain_text_password) do
    query = from(u in User, where: u.email == ^email)

    case Repo.one(query)
         |> Repo.preload(:teams) do
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

  def get_current_user(conn) do
    case Guardian.decode_and_verify(Map.get(conn.cookies, "access_token")) do
      {:ok, data} ->
        user = get_user!(data["sub"])
        {:ok, user}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
