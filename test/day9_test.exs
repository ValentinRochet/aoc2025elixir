defmodule Day9Test do
  use ExUnit.Case
  doctest Day9

  test "day9part1" do
    assert Day9.part1("input/day9-example") == 50
  end

  test "day9part2" do
    assert Day9.part2("input/day9-example") == 24
  end
end
