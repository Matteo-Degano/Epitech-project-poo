defmodule Api.ClockingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Api.Clocking` context.
  """

  @doc """
  Generate a clocks.
  """
  def clocks_fixture(attrs \\ %{}) do
    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 14:13:00]
      })
      |> Api.Clocking.create_clocks()

    clocks
  end
end
