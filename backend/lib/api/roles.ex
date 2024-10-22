defmodule Api.Roles do
  alias Api.Repo

  alias Api.Roles.Role

  def get_role!(id) do
    Repo.get!(Role, id)
  end
end
