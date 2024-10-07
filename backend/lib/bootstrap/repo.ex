defmodule Todolist.Repo do
  use Ecto.Repo,
    otp_app: :bootstrap,
    adapter: Ecto.Adapters.Postgres
end
