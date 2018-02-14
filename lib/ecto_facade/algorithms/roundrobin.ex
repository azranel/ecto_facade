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
      Agent.get_and_update(__MODULE__, fn [current_repo | other_repos] ->
        {current_repo, other_repos ++ [current_repo]}
      end)
    end
  end
end
