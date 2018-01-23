defmodule EctoFacade.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ecto_facade,
      version: "0.1.1",
      description: "Ecto Facade Repository that allows to separate write from read operations",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, ">= 2.0.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package() do
    [
      maintainers: ["Bart Lecki"],
      licenses: ["MIT License"],
      links: %{"GitHub" => "https://github.com/azranel/ecto_facade"},
      source_url: "https://github.com/azranel/ecto_facade",
      homepage_url: "https://github.com/azranel/ecto_facade"
    ]
  end
end
