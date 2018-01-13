# EctoFacade

EctoFacade can be used as interface through which you can query multiple repositories.
Main objective of this is to use separate separate repository for writes and separate repository for reads.

For example:

Lets say you have PostgreSQL database replicated to 4 different slave nodes that should be used for reads only.
With this small library you can do that!

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_facade` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_facade, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ecto_facade](https://hexdocs.pm/ecto_facade).

