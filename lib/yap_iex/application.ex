defmodule YapIEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    maybe_show_log_path()

    children = [
      # {Ratatouille.Runtime.Supervisor, runtime: [app: YapIEx.TerminalApp]}

      # just to test a single component
      # {Ratatouille.Runtime.Supervisor, runtime: [app: YapIEx.Components.MultiModalText]}
    ]

    Logger.info("Starting application with children: #{inspect(children)}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YapIEx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() == :dev do
    defp maybe_show_log_path do
      log_path = Application.get_env(:logger, :everything)[:path]

      IO.puts("Logging to #{log_path} ...")
      # sleep a bit for us to see the log_path before the terminal blocked
      Process.sleep(2000)
    end
  else
    defp maybe_show_log_path, do: :ok
  end
end
