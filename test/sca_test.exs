defmodule ScaTest do
  use ExUnit.Case
  doctest Sca

  test "greets the world" do
    assert Sca.hello() == :world
  end
end
