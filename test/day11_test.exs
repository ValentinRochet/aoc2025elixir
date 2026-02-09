defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "day11part1" do
    assert Day11.part1("input/day11-example") == 5
  end

  test "day11part2" do
    assert Day11.part2("input/day11-example-part-2") == 2
  end
end
