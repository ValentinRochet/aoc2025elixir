defmodule Day2Test do
  use ExUnit.Case
  doctest Day2

  test "day2part1" do
    assert Day2.part1("input/day2-example") == 1227775554
  end

  test "day2part2" do
    assert Day2.part2("input/day2-example") == 6
  end
end
