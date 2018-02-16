# EctoFacade

EctoFacade can be used as interface through which you can query multiple repositories.
Main objective of this is to use separate separate repository for writes and separate repository for reads.

For example:

Lets say you have PostgreSQL database replicated to 4 different slave nodes that should be used for reads only.
With this small library you can do that!

## Installation

```elixir
def deps do
  [
    {:ecto_facade, "~> 0.2.0"}
  ]
end
```

## Usage

Here is example on how to use `EctoFacade` in your application:

```elixir
defmodule MyApp.FacadeRepo do
  use EctoFacade.Repo,
    master_repo: MyApp.Repo,
    read_repos: [MyApp.ReadReplicaOne, MyApp.ReadReplicaTwo],
    algorithm: MyApp.Repo.ReadAlgorithm,
    fallback_to_master: false
end

MyApp.FacadeRepo.all(MyApp.SomeSchema) # and other operations that you would normally do with ecto repo
```

Options you can pass when `using` `EctoFacade.Repo` are:
- `master_repo` - this is master repository that will be used for all write operations
- `read_repos` - this is list of read repositories that will be used for all read operations. Which repository will be used depends on `algorithm`.
- `algorithm` - this is module that implements behaviour `EctoFacade.Algorithm` and picks read repository for next read operation.
- `fallback_to_master` - if set to true then read operation that won't work on read repository, will fallback to master repostiory. If set to false, it will throw exception.

Possible algorithms for selecting repository for read operation:
- `EctoFacade.Algorithms.Random` - selects randomly repository
- `EctoFacade.Algorithms.Roundrobin` - selects next repository in list till last and then goes again from beginning
- `EctoFacade.Algorithms.WeightRoundrobin` - selects next repository in list depending on weight. Check module documentation for more info.

or your own that implement behaviour `EctoFacade.Algorithm`.

for more information please check documentation

### How to write my own algorithm?

This is pretty straightforward. Here is implementation of `EctoFacade.Algorithms.Random`:

```elixir
defmodule EctoFacade.Algorithms.Random do
  @moduledoc """
  Default algorithm that just returns random read repository
  """
  @behaviour EctoFacade.Algorithm

  def get_repo(repos) do
    Enum.random(repos)
  end
end
```

## Usage (testing)

When in test just configure you FacadeRepo to use only master repository. This way you won't have issues with separate repositories with Sandbox Ecto adapter.

## Documentation

[Hex.pm](https://hexdocs.pm/ecto_facade)

