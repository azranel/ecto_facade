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

  """
  @behaviour EctoFacade.Algorithm
  alias EctoFacade.Algorithms.WeightRoundrobin.Storage

  def get_repo(repos) do
    Storage.start_link(repos)
    Storage.get_next_repo()
  end

  defmodule Storage do
    use Agent

    def start_link(repos) do
      ordered_repos = repos |> Enum.flat_map(fn ({repo, weight}) ->
        List.duplicate([repo], weight + 1)
      end) |> List.flatten
      Agent.start_link(fn -> ordered_repos end, name: __MODULE__)
    end

    def get_next_repo() do
      [current_repo | repos_without_current] = Agent.get(__MODULE__, & &1)
      new_repos = repos_without_current ++ [current_repo]
      Agent.update(__MODULE__, fn _ -> new_repos end)
      current_repo
    end
  end
end
