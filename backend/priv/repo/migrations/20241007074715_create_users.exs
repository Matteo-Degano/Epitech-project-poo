defmodule Api.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users) do
      add :username, :string
      add :email, :string
      add :password, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, :username)
    create unique_index(:users, :email)
  end
end
