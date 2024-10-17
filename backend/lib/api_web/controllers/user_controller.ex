defmodule ApiWeb.UserController do
  import Ecto.Query
  use ApiWeb, :controller

  alias Api.Users
  alias Api.Users.User
  alias Api.Repo

  action_fallback ApiWeb.FallbackController

  def index(conn, %{"username" => username, "email" => email}) do
    users = Users.list_users_by_username_and_email(username, email)
    render(conn, :index, users: users)
  end

  def index(conn, _params) do
    current_user = conn.assigns.current_user
    users = Users.list_users_by_manager(current_user.id)
    render(conn, :index, users: users)
  end

  def create(conn, %{"username" => username, "email" => email, "role" => role, "team" => team}) do
    current_user = conn.assigns.current_user

    # Vérifiez si l'utilisateur courant a le droit de créer un utilisateur (par exemple, s'il est un general_manager ou un admin)
    if current_user.role == "manager" or current_user.role == "general_manager" or current_user.role == "admin" do
      user_params = %{"username" => username, "email" => email, "role" => role, "team" => team}

      with {:ok, %User{} = user} <- Users.create_user(user_params) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:show, user: user)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Vous n'avez pas accès à créer un nouvel employé."})
    end
  end


  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "username" => username, "email" => email, "role" => role, "team" => team}) do
    current_user = conn.assigns.current_user
    user_to_update = Users.get_user!(id)

    # Vérifiez si l'utilisateur courant est le manager de l'utilisateur à modifier ou s'il est un general_manager
    if user_to_update.manager_id == current_user.id or current_user.role == "general_manager" or current_user.role == "admin" do
      user_params = %{"username" => username, "email" => email, "role" => role, "team" => team}

      with {:ok, %User{} = user} <- Users.update_user(user_to_update, user_params) do
        render(conn, :show, user: user)
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Vous n'avez pas accès à modifier cet employé."})
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns.current_user
    user_to_delete = Users.get_user!(id)

    # Vérifiez si l'utilisateur courant est le manager de l'utilisateur à supprimer ou s'il est un general_manager ou un admin
    if user_to_delete.manager_id == current_user.id or current_user.role == "general_manager" or current_user.role == "admin" do
      with {:ok, %User{}} <- Users.delete_user(user_to_delete) do
        send_resp(conn, :no_content, "")
      end
    else
      conn
      |> put_status(:forbidden)
      |> json(%{error: "Vous n'avez pas accès à supprimer cet employé."})
    end
  end


  def get_users_by_team(conn, %{"team" => team}) do
    users =
      User
      |> where([u], u.team == ^team)
      |> Repo.all()
    render(conn, :index, users: users)
  end
end
