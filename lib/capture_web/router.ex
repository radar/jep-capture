defmodule CaptureWeb.Router do
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug Plug.Parsers, parsers: [:urlencoded, :json],
  json_decoder: Jason

  plug :match
  plug :dispatch

  post "/responses" do
    send_resp(conn, 200, "OK")
  end
end
