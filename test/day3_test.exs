defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "day3part1" do
    assert Day3.part1("input/day3-example") == 357
  end

  test "day3part2" do
    assert Day3.part2("input/day3-example") == 3121910778619
  end
end
