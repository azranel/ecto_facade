defmodule EctoFacade.Algorithms.WeightRoundrobin do
  @moduledoc """
  Algorithm that selects read repository, based on weight.
  The bigger weight indicates that repo should be used more frequently.
  By default, each repo have assigned weight 0.

  Example:
    read_repos = [{RepoOne, 0}, {RepoTwo, 2}, {RepoThree, 1}]

    order in which what repos will be used:
    1. RepoOne
    2. RepoTwo
    3. RepoTwo
    4. RepoTwo
    5. RepoThree
    6. RepoThree
    7. RepoOne
    etc etc etc
  """

  @behaviour EctoFacade.Algorithm

  alias EctoFacade.Algorithms.Roundrobin

  def get_repo(repos) do
    repos
    |> build_list()
    |> Roundrobin.get_repo()
  end

  defp build_list(repos) do
    Enum.flat_map(repos, fn ({repo, weight}) ->
      List.duplicate(repo, weight + 1)
    end)
  end
end
