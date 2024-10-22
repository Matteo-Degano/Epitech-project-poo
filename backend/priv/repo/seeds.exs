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
alias Api.Users.User
alias Api.Roles.Role
alias Api.Team
alias Api.Workingtimes.Workingtime
alias Api.UsersTeams

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
  %{name: "Developpeur Front-end"},
  %{name: "Développeur Back-end"},
  %{name: "Développeur Fullstack"},
  %{name: "Ingénieur Robotique"},
  %{name: "DevOps"},
  %{name: "Marketing"},
  %{name: "Sales"},
  %{name: "Support"},
  %{name: "Management"},
  %{name: "RH"},
  %{name: "Finance"}
]

teams =
  Enum.each(team_data, fn team ->
    Repo.insert!(Team.changeset(%Team{}, team))
  end)

IO.inspect(teams, label: "Teams inserted by seeder")


users = [
  %{username: "L'admin", email: "admin@epitech.eu", password: "password", role_id: 4, team_ids: [1]},
  %{username: "Le général manager", email: "generalmanager@epitech.eu", password: "password", role_id: 3, team_ids: [1]},
  %{username: "Le manager", email: "manager@epitech.eu", password: "password", role_id: 2, team_ids: [1]},
  %{username: "Le user", email: "user@epitech.eu", password: "password", role_id: 1, team_ids: [1]},
  %{username: "John Doe", email: "johndoe@epitech.eu", password: "password", role_id: 1, team_ids: [1, 3, 10]},
  %{username: "Jane Doe", email: "janedoe@epitech.eu", password: "password", role_id: 1, team_ids: [4, 6]},
  %{username: "Jane Smith", email: "janesmith@epitech", password: "password", role_id: 1, team_ids: [7, 8]},
  %{username: "Marie Jane", email: "mariejane@epitech", password: "password", role_id: 1, team_ids: [1, 2, 3, 7, 8]},
  %{username: "Luke Skywalker", email: "lukeskywalker@epitech", password: "password", role_id: 1, team_ids: [1, 8, 9]},
  %{username: "Theo Lepage", email: "theolepage@epitech", password: "password", role_id: 1, team_ids: [4,11]},
  %{username: "Jean Dupont", email: "jeandupont@epitech", password: "password", role_id: 1, team_ids: [3]},
  %{username: "Doriyan Volkiviz", email: "doriyanvolkiviz@epitech.eu", password: "motdepasse", role_id: 1, team_ids: [1, 2, 3]},
]

users =
  Enum.map(users, fn user ->
    inserted_user = Repo.insert!(User.changeset(%User{}, user))

    IO.inspect(inserted_user.username, label: "User inserted by seeder")

    Enum.each(user.team_ids, fn team_id ->
      users_team_changeset =
        UsersTeams.changeset(%UsersTeams{}, %{
          user_id: inserted_user.id,
          team_id: team_id
        })
      IO.inspect(users_team_changeset, label: "Team inserted by seeder")
      Repo.insert(users_team_changeset)
    end)

    Enum.each(0..90, fn (i) ->
      date = Date.add(Date.utc_today(), i)

      {:ok, start_time} = Time.new(9, Enum.random(15..45), Enum.random(0..59))
      {:ok, end_time} = Time.new(17, Enum.random(15..45), Enum.random(0..59))

      {:ok, start_naive_datetime} = NaiveDateTime.new(date, start_time)
      {:ok, end_naive_datetime} = NaiveDateTime.new(date, end_time)

      workingtime_changeset = Workingtime.changeset(%Workingtime{}, %{
        start: start_naive_datetime,
        end: end_naive_datetime,
        user_id: inserted_user.id
      })

      Repo.insert(workingtime_changeset)
    end)

  end)

IO.inspect(users, label: "Users, User Teams and Working Times inserted by seeder")
