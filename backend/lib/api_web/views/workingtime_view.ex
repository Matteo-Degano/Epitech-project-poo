defmodule ApiWeb.WorkingtimeView do
  use ApiWeb, :view

  def render("index.json", %{workingtimes: workingtimes}) do
    %{workingtimes: render_many(workingtimes, ApiWeb.WorkingtimeView, "workingtime.json")}
  end

  def render("show.json", %{workingtime: workingtime}) do
    %{workingtime: render_one(workingtime, ApiWeb.WorkingtimeView, "workingtime.json")}
  end

  def render("workingtime.json", %{workingtime: workingtime}) do
    %{
      id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end,
      user_id: workingtime.user_id
    }
  end
end