defmodule EctoFacade.Algorithms.Random do
  @behaviour EctoFacade.Algorithm

  def get_repo(repos) do
    Enum.random(repos)
  end
end