defmodule ApiWeb.Router do
  # alias ApiWeb.UserController
  alias Api.Plug.AuthorizeRole
  use ApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Api.Plug.CheckCookie)
  end

  pipeline :role_admin do
    plug(AuthorizeRole, "admin")
  end

  pipeline :role_general_manager do
    plug(AuthorizeRole, "general_manager")
  end

  pipeline :role_manager do
    plug(AuthorizeRole, "manager")
  end

  pipeline :role_user do
    plug(AuthorizeRole, "user")
  end

  options "/*path", Corsica,
    origins: "*",
    allow_methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allow_headers: ["content-type", "authorization", "api_key"]

  scope "/api", ApiWeb do
    pipe_through([:api])

    # Users
    post("/login", AuthController, :login)
    post("/refresh", AuthController, :refresh)
    post("/logout", AuthController, :logout)

    resources("/users", UserController, except: [:new, :edit])
  end

  scope "/api", ApiWeb do
    pipe_through([:api, :auth, :role_user])

    #  Charts
    get("/chartmanager/:userID", ChartManagerController, :show)

    #  Teams
    get("/teams/workingtimes", TeamController, :workingtimes)
    get("/teams/:id", TeamController, :show)
    get("/teams", TeamController, :index)
    post("/teams", TeamController, :create)
    put("/teams/:id", TeamController, :update)
    delete("/teams/:id", TeamController, :delete)

    # Workingtimes
    get("/workingtime", WorkingtimeController, :show)
    get("/workingtime/:user", WorkingtimeController, :index)
    get("/workingtime/:user/:id", WorkingtimeController, :show)
    post("/workingtime/:user", WorkingtimeController, :create)
    put("/workingtime/:id", WorkingtimeController, :update)
    delete("/workingtime/:id", WorkingtimeController, :delete)

    # Clocks
    get("/clocks/:user", ClocksController, :show)
    post("/clocks/:user", ClocksController, :create)
  end

  scope "api", ApiWeb do
    pipe_through([:api, :auth, :role_general_manager])

    # Users
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: ApiWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
