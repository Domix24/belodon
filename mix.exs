defmodule Belodon.MixProject do
  use Mix.Project

  def project do
    [
      app: :belodon,
      version: "0.3.0",
      elixir: "~> 1.19",
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
      source_url: "https://github.com/domix24/belodon",
      docs: [
        before_closing_body_tag: &before_closing_body_tag/1
      ]
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
      {:tesla, "~> 1.15"},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.39", only: :dev, runtime: false}
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

  defp before_closing_body_tag(:epub), do: ""

  defp before_closing_body_tag(:html) do
    """
    <script type="module">
    import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs"

    mermaid.initialize({
      theme: "dark"
    })
    </script>
    """
  end
end
