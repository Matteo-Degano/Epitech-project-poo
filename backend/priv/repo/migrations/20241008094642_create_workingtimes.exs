defmodule Api.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:workingtimes) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
