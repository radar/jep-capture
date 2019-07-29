defmodule Capture.Repo do
  use Ecto.Repo,
    otp_app: :capture,
    adapter: Ecto.Adapters.Postgres
end
