defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug ApiWeb.Plugs.AuthenticateUser
  end

  pipeline :authorize_employee do
    plug ApiWeb.Plugs.AuthorizeRole, role: :employee
  end

  pipeline :authorize_manager do
    plug ApiWeb.Plugs.AuthorizeRole, role: :manager
  end

  pipeline :authorize_general_manager do
    plug ApiWeb.Plugs.AuthorizeRole, role: :general_manager
  end

  pipeline :authorize_admin do
    plug ApiWeb.Plugs.AuthorizeRole, role: :admin
  end

  scope "/api", ApiWeb do
    pipe_through :api
    pipe_through :authenticated

    # Routes pour les utilisateurs
    scope "/users" do
      pipe_through [:authorize_employee, :authorize_manager, :authorize_general_manager, :authorize_admin]

      get("/me", UserController, :show_self)     # Voir ses propres données
      patch("/me", UserController, :update_self)  # Modifier ses propres données
      delete("/me", UserController, :delete_self) # Supprimer ses propres données
    end

    # Routes pour la gestion des utilisateurs
    scope "/users" do
      pipe_through [:authorize_manager, :authorize_general_manager, :authorize_admin]

      post("/", UserController, :create)          # Créer un utilisateur
      get("/", UserController, :index)            # Voir tous les utilisateurs
      get("/:id", UserController, :show)          # Voir un utilisateur spécifique
      put("/:id", UserController, :update)        # Modifier un utilisateur
      delete("/:id", UserController, :delete)     # Supprimer un utilisateur
    end

    # Routes pour les workingtimes
    scope "/workingtime" do
      pipe_through [:authorize_manager, :authorize_general_manager, :authorize_admin]

      post("/", WorkingtimeController, :create)      # Créer un workingtime
      get("/", WorkingtimeController, :index)        # Voir tous les workingtimes
      get("/:id", WorkingtimeController, :show)      # Voir un workingtime spécifique
      put("/:id", WorkingtimeController, :update)     # Modifier un workingtime
      delete("/:id", WorkingtimeController, :delete)  # Supprimer un workingtime
    end

    # Routes pour les clocks
    scope "/clocks" do
      pipe_through [:authorize_employee, :authorize_manager, :authorize_general_manager, :authorize_admin]

      post("/", ClocksController, :create)         # Créer un clock pour soi-même
      put("/:id", ClocksController, :update_self)   # Modifier sa clock
    end

    # Routes pour les administrateurs
    scope "/admin" do
      pipe_through :authorize_admin
      # Noting yet
    end
  end
end
