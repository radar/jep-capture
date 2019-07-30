use Mix.Config

config :capture, Capture.Repo,
  database: "capture_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
