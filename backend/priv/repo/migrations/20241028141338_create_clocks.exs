defmodule Api.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:clocks) do
      add :time, :naive_datetime
      add :status, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:clocks, [:user_id])
  end
end
