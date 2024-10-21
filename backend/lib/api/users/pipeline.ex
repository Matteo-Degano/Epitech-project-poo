defmodule Api.Users.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :api,
    error_handler: Api.Users.ErrorHandler,
    module: Api.Users.Guardian

  plug(Api.Plug.CheckCookie)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
