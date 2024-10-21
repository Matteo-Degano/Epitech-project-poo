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
alias Api.Role
alias Api.Team

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

team_data = [
  %{name: "Development"},
  %{name: "DevOps"},
  %{name: "Marketing"},
  %{name: "Sales"},
  %{name: "Support"},
  %{name: "Management"},
  %{name: "RH"},
  %{name: "Finance"}
]

# Insert teams
teams =
  Enum.each(team_data, fn team ->
    Repo.insert!(Team.changeset(%Team{}, team))
  end)

IO.inspect(teams, label: "Teams inserted by seeder")

# Users
# email, username, team_id, role_id
users = [
  {"L'admin", "admin@epitech.eu", "postgres", 4, [1]},
]
