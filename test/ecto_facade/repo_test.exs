defmodule EctoFacade.RepoTest do
  use ExUnit.Case

  require EctoFacade.TestRepo, as: TestRepo
  require EctoFacade.TestRepo, as: TestReadRepoOne
  require EctoFacade.TestRepo, as: TestReadRepoTwo

  defmodule TestFacadeRepo do
    use EctoFacade.Repo, master_repo: TestRepo
  end

  defmodule TestFacadeComplexRepo do
    use EctoFacade.Repo,
      master_repo: TestRepo,
      read_repos: [TestReadRepoOne, TestReadRepoTwo]
  end

  describe "master_repo/0" do
    test "master_repo/0 should return master repository" do
      assert TestFacadeRepo.master_repo() == TestRepo
    end
  end

  describe "read_repos/0" do
    test "read_repos/0 should return list containing master repo only by default" do
      assert TestFacadeRepo.read_repos() == [TestRepo]
    end

    test "read_repos/0 should return list of read repos when configured" do
      assert TestFacadeComplexRepo.read_repos() == [TestReadRepoOne, TestReadRepoTwo]
    end
  end
end
