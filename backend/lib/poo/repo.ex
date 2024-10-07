defmodule TimeManager.Repo do
  use Ecto.Repo,
    otp_app: :poo,
    adapter: Ecto.Adapters.Postgres
end
