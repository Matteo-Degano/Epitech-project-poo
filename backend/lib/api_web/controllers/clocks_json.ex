defmodule ApiWeb.ClocksJSON do
  alias Api.Clocking.Clocks

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clocks <- clocks, do: data(clocks))}
  end

  @doc """
  Renders a single clocks.
  """
  def show(%{clocks: clocks}) do
    %{data: data(clocks)}
  end

  defp data(%Clocks{} = clocks) do
    %{
      id: clocks.id,
      time: clocks.time,
      status: clocks.status
    }
  end
end
