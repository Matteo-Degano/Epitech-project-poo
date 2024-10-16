defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :auth do
    plug(Api.Users.Pipeline)
  end

  scope "/api", ApiWeb do
    pipe_through([:api])

    post("/login", AuthController, :login)
    # post("/refresh", AuthController, :refresh)
    # post("/logout", AuthController, :logout)

    resources("/users", UserController, except: [:new, :edit])
  end

  scope "/api", ApiWeb do
    pipe_through([:api, :auth])

    get("/workingtime/:user", WorkingtimeController, :index)
    get("/workingtime/:user/:id", WorkingtimeController, :show)
    post("/workingtime/:user", WorkingtimeController, :create)
    put("/workingtime/:id", WorkingtimeController, :update)
    delete("/workingtime/:id", WorkingtimeController, :delete)

    get("/clocks/:user", ClocksController, :show)
    post("/clocks/:user", ClocksController, :create)
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
