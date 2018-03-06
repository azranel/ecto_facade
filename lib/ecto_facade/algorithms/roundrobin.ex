defmodule EctoFacade.Algorithms.Roundrobin do
  @moduledoc """
  Algorithm for ecto facade to return next repository
  """

  @behaviour EctoFacade.Algorithm

  defmodule Storage do
    use Agent

    def start_link(repos) do
      Agent.start_link(fn -> :queue.from_list(repos) end, name: __MODULE__)
    end

    def get_next_repo() do
      Agent.get_and_update(__MODULE__, fn queue ->
        {{:value, current_repo}, tail} = :queue.out(queue)

        {current_repo, :queue.in(current_repo, tail)}
      end)
    end
  end

  def get_repo(repos) do
    Storage.start_link(repos)
    Storage.get_next_repo()
  end
end
