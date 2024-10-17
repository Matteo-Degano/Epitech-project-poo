defmodule ApiWeb.RoleHierarchy do
  @roles %{
    "employee" => 1,
    "manager" => 2,
    "general_manager" => 3,
    "admin" => 4
  }

  def has_sufficient_role?(user_role, required_role) do
    @roles[user_role] >= @roles[required_role]
  end
end
