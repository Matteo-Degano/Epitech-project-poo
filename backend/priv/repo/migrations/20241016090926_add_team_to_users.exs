defmodule Api.Repo.Migrations.AddTeamToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :team_id, references(:teams, on_delete: :nothing)
    end

    create index(:users, [:team_id])
  end
end
