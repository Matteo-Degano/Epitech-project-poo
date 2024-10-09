defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ApiWeb do
    pipe_through :api

    get "/clocks/:user", ClocksController, :show

    post "/clocks/:user", ClocksController, :create

    resources "/users", UserController, except: [:new, :edit]

        # GET (ALL) - Fetch all working time entries for a user
    get "/workingtime/:userID", WorkingtimeController, :index

    # GET (ONE) - Fetch a single working time entry
    get "/workingtime/:userID/:id", WorkingtimeController, :show

    # POST - Create a new working time entry
    post "/workingtime/:userID", WorkingtimeController, :create

    # PUT - Update a working time entry
    put "/workingtime/:id", WorkingtimeController, :update

    # DELETE - Delete a working time entry
    delete "/workingtime/:id", WorkingtimeController, :delete
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
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: ApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
