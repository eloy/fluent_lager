defmodule FluentLager.Mixfile do
  use Mix.Project

  def project do
    [app: :fluent_lager,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:lager, :msgpack],
     mod: {FluentLager, []}]
  end

  defp deps do
    [
      {:lager, github: "basho/lager"},
      {:msgpack, "~> 0.5.0"}
    ]
  end
end
