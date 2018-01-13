defmodule EctoFacadeTest do
  use ExUnit.Case
  doctest EctoFacade

  test "greets the world" do
    assert EctoFacade.hello() == :world
  end
end
