defmodule Api.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    belongs_to :team, Api.Teams.Team
    belongs_to :role, Api.Roles.Role

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :team_id, :role_id])
    |> validate_required([:username, :email])
  end
end
