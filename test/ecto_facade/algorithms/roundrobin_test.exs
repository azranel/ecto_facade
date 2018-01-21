defmodule EctoFacade.Algorithms.RoundrobinTest do
  use ExUnit.Case

  test "should cycle between repositories" do
    repos = [1,2,3]
    assert 1 == EctoFacade.Algorithms.Roundrobin.get_repo(repos)
    assert 2 == EctoFacade.Algorithms.Roundrobin.get_repo(repos)
    assert 3 == EctoFacade.Algorithms.Roundrobin.get_repo(repos)
    assert 1 == EctoFacade.Algorithms.Roundrobin.get_repo(repos)
  end
end
