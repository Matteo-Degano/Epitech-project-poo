defmodule Api.Users.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api,
    error_handler: Api.Users.ErrorHandler,
    module: Api.Users.Guardian

  plug(Guardian.Plug.VerifyHeader,
    refresh_from_cookie: true,
    claims: %{"typ" => "access"},
    ttl: {8, :hours}
  )

  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
