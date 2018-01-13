defmodule EctoFacade.Algorithms.Random do
  @moduledoc """
  Default algorithm that just returns random read repository
  """
  @behaviour EctoFacade.Algorithm

  def get_repo(repos) do
    Enum.random(repos)
  end
end