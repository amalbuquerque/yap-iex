defmodule YapIEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :yap_iex,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {YapIEx.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ratatouille, "~> 0.5.0"},
      {:logger_file_backend, "~> 0.0.13"}
    ]
  end
end
