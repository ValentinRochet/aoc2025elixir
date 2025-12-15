defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "day6part1" do
    assert Day6.part1("input/day6-example") == 4277556
  end

  test "day6part2" do
    assert Day6.part2("input/day6-example") == 3263827
  end
end
