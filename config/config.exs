import Config

config :logger, backends: [{LoggerFileBackend, :everything}]

log_name =
  DateTime.utc_now()
  |> Map.put(:microsecond, {0, 0})
  |> DateTime.to_iso8601(:basic)
  |> Kernel.<>(".log")

config :logger, :everything,
  path: "./" <> log_name,
  level: :debug
