defmodule ApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :api

  # Update Corsica settings to allow specific origins and credentials

  plug Corsica,
    origins: ["http://localhost:8081"],  # Allow specific origin
    allow_headers: ["content-type", "authorization", "api_key"],  # Allowed headers
    allow_credentials: true  # Allow cookies, Authorization headers, etc.


  # The rest of your endpoint code remains the same

  @session_options [
    store: :cookie,
    key: "_api_key",
    signing_salt: "u6U6sIww",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :api,
    gzip: false,
    only: ApiWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :api
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ApiWeb.Router
end
