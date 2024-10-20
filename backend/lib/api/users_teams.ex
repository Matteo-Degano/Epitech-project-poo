defmodule Api.UsersTeams do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_teams" do
    field :user_id, :id
    field :team_id, :id
    timestamps()
  end

  def changeset(users_team, attrs) do
    users_team
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
  end

end
