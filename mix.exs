defmodule Tremorx.MixProject do
  use Mix.Project

  @name :tremorx
  @version "0.1.0"
  @description "An Elixir Phoenix component library inspired by [Tremor](https://www.tremor.so/) - The react library to build dashboards fast."
  @github_url "https://github.com/briankariuki/tremorx"

  def project do
    [
      app: @name,
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      docs: docs(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      maintainers: ["Brian Kariuki"],
      description: @description,
      licenses: ["MIT"],
      links: %{Github: @github_url},
      files: ~w(mix.exs assets lib .formatter.exs LICENSE.md  README.md)
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7.10"},
      {:phoenix_live_view, "~> 0.20"},
      {:tails, "~> 0.1.5"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false}
    ]
  end

  def docs() do
    [
      homepage_url: @github_url,
      source_url: @github_url,
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md": [title: "Guide"],
        "LICENSE.md": [title: "License"]
      ]
    ]
  end

  defp aliases() do
    [
      docs: ["docs"]
    ]
  end
end
