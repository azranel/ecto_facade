defmodule EctoFacade.Algorithms.Roundrobin do
  @moduledoc """
  Algorithm for ecto facade to return next repository
  """
  @behaviour EctoFacade.Algorithm
  alias EctoFacade.Algorithms.Roundrobin.Storage

  def get_repo(repos) do
    Storage.start_link(repos)
    Storage.get_next_repo()
  end

  defmodule Storage do
    use Agent

    def start_link(repos) do
      Agent.start_link(fn -> repos end, name: __MODULE__)
    end

    def get_next_repo() do
      [current_repo | repos_without_current] = Agent.get(__MODULE__, & &1)
      new_repos = repos_without_current ++ [current_repo]
      Agent.update(__MODULE__, fn _ -> new_repos end)
      current_repo
    end
  end
end
