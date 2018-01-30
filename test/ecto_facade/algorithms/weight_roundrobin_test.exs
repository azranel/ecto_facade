defmodule EctoFacade.Algorithms.WeightRoundrobinTest do
  use ExUnit.Case

  alias EctoFacade.Algorithms.WeightRoundrobin

  test "should cycle between repositories" do
    repos = [{1, 0}, {2, 2}, {3, 1}]
    assert 1 == WeightRoundrobin.get_repo(repos)
    assert 2 == WeightRoundrobin.get_repo(repos)
    assert 2 == WeightRoundrobin.get_repo(repos)
    assert 2 == WeightRoundrobin.get_repo(repos)
    assert 3 == WeightRoundrobin.get_repo(repos)
    assert 3 == WeightRoundrobin.get_repo(repos)
    assert 1 == WeightRoundrobin.get_repo(repos)
  end
end
