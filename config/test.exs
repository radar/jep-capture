use Mix.Config

config :capture, Capture.Repo,
  database: "capture_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
