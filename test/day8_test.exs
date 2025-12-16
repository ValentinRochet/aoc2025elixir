defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "day8part1" do
    assert Day8.part1("input/day8-example", 10) == 40
  end

  test "day8part2" do
    assert Day8.part2("input/day8-example") == 25272
  end
end
