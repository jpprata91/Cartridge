defmodule Cartridge.MixProject do
  use Mix.Project

  def project do
    [
      app: :cartridge,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Cartridge.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
defp deps do
  [
    {:nostrum, "~> 0.10.4"},
    {:httpoison, "~> 2.0"},
    {:jason, "~> 1.4"}
  ]
end
end
