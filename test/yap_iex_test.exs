defmodule YapIExTest do
  use ExUnit.Case
  doctest YapIEx

  test "greets the world" do
    assert YapIEx.hello() == :world
  end
end
