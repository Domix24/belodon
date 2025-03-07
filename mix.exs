defmodule Belodon.MixProject do
  use Mix.Project

  def project do
    [
      app: :belodon,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [
        plt_add_apps: [:mix],
        plt_local_path: "priv/plts"
      ],
      package: [
        licenses: ["MIT"],
        links: %{"github" => "https://github.com/domix24/belodon"},
        description: "Wrapper for Advent of Code with Elixir",
        files: ["lib-dev", "lib", "mix.exs", "template"]
      ],
      source_url: "github.com/domix24/belodon"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:tesla, "~> 1.13"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  # Directories to find source files. Defaults to ["lib"] (from Mix compile.elixir)
  defp elixirc_paths(:test) do
    [
      "lib",
      # mocks
      "lib-test"
    ]
  end

  defp elixirc_paths(_) do
    [
      "lib",
      # mocks
      "lib-dev"
    ]
  end
end
