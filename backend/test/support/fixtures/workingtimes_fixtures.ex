defmodule Api.WorkingtimesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Api.Workingtimes` context.
  """

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-07 09:46:00Z],
        start: ~U[2024-10-07 09:46:00Z],
        user_id: 42
      })
      |> Api.Workingtimes.create_workingtime()

    workingtime
  end
end
