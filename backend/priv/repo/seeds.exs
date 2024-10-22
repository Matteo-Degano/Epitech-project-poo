# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Api.Repo.insert!(%Api.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Api.Repo
# alias Api.Users.Users
alias Api.Roles.Role
# alias Api.Team

role_data = [
  %{name: "user"},
  %{name: "manager"},
  %{name: "general_manager"},
  %{name: "admin"}
]

roles =
  Enum.map(role_data, fn role ->
    Repo.insert!(Role.changeset(%Role{}, role))
  end)

IO.inspect(roles, label: "Roles inserted by seeder")
