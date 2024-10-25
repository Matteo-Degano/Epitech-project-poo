defmodule Api.Clocks do
  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Clocks.Clock

  def list_clocks do
    Repo.all(Clock)
  end

  def get_clocks!(id), do: Repo.get!(Clock, id)

  def get_clocks_by_user(id) do
    Repo.all(
      from(clock in Clock,
        where: clock.user_id == ^id
      )
    )
  end

  def create_clocks(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def update_clocks(%Clock{} = clocks, attrs) do
    clocks
    |> Clock.changeset(attrs)
    |> Repo.update()
  end

  def delete_clocks(%Clock{} = clocks) do
    Repo.delete(clocks)
  end

  def change_clocks(%Clock{} = clocks, attrs \\ %{}) do
    Clock.changeset(clocks, attrs)
  end

  def has_active_clock(user_id) do
    query = from(c in Clock, where: c.user_id == ^user_id and c.status == true)

    Repo.one(query)
  end
end
