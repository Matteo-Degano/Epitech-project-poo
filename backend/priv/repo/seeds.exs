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

# Roles
roles = ["Admin", "General Manager", "Manager", "Employee"]

# Insert roles
Enum.each(roles, fn role -> Api.Repo.insert!(%Api.Role{name: role}) end)

# Teams
teams = ["Development", "DevOps", "Marketing", "Sales", "Support", "Management", "RH", "Finance"]

# Insert teams
Enum.each(teams, fn team -> Api.Repo.insert!(%Api.Team{name: team}) end)

# Users
# email, username, team_id, role_id
users = [
  {"admin@example.com", "L'Admin", 1, 1},
  # {"general_manager@example.com", "Le General Manager", 1, 2},
  # {"manager@example.com", "Le Manager", 2, 3},
  # {"john.doe@example.com", "John doe", 2, 4},
  # {"olivia.brown@example.com", "olivia_brown", 3, 4},
  # {"noah.jones@example.com", "noah_jones", 3, 4},
  # {"ava.garcia@example.com", "ava_garcia", 4, 4},
  # {"elijah.martinez@example.com", "elijah_martinez", 4, 4},
  # {"sophia.rodriguez@example.com", "sophia_rodriguez", 5, 4},
  # {"lucas.hernandez@example.com", "lucas_hernandez", 5, 4},
  # {"mia.moore@example.com", "mia_moore", 6, 4}
]

# Insert users and generate working times
Enum.each(users, fn {email, username, team_id, role_id} ->
  user = Api.Repo.insert!(%Api.Users.User{email: email, username: username, team_id: team_id, role_id: role_id})

  start_date = DateTime.utc_now();
  {hour, minute, second} = {9, 30, 0}
  start_date = DateTime.new!(start_date.date, {hour, minute, second}, "Etc/UTC")

  IO.inspect(start_date)

  # Enum.each(0..29, fn day_offset ->

    # date = DateTime.add(start_date, day_offset, :day)

    # if Date.day_of_week(date) not in [6, 7] do

    #   IO.inspect(date)

    #   start_time = DateTime.add(date, (60 * 60 + 30) * 60, :second)
    #   end_time = DateTime.add(date, (60 * 60 + 30) * 60, :second)

    #   IO.inspect({start_time, end_time})


    #   start_time = DateTime.add(start_time, :rand.uniform(60 * 15), :second)
    #   end_time = DateTime.add(end_time, :rand.uniform(60 * 15), :second)

    #   start_naive = DateTime.to_naive(start_time) |> NaiveDateTime.truncate(:second)
    #   end_naive = DateTime.to_naive(end_time) |> NaiveDateTime.truncate(:second)

    #   Api.Repo.insert!(%Api.Workingtimes.Workingtime{start: start_naive, end: end_naive, user_id: user.id})
    # end
  # end)
end)
