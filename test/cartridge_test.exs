defmodule CartridgeTest do
  use ExUnit.Case
  doctest Cartridge

  test "greets the world" do
    assert Cartridge.hello() == :world
  end
end
