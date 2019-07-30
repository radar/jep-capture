defmodule CaptureWeb.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  post "/responses" do
    send_resp(conn, 200, "OK")
  end
end
