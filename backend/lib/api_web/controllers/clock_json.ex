defmodule ApiWeb.ClockJSON do
  alias Api.Clocks.Clock

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

  defp data(%Clock{} = clocks) do
    %{
      id: clocks.id,
      time: clocks.time,
      status: clocks.status,
      user_d: clocks.user_id
    }
  end
end
