defmodule Api.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:email, :string)
    field(:password, :string)
    belongs_to :role, Api.Roles.Role
    many_to_many :teams, Api.Teams.Team, join_through: "users_teams"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username, :email, :password, :role_id])
    |> validate_required([:username, :email, :password, :role_id])
    |> foreign_key_constraint(:team_id)
    |> foreign_key_constraint(:role_id)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
