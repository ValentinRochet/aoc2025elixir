defmodule Day7Test do
  use ExUnit.Case
  doctest Day7

  test "day7part1" do
    assert Day7.part1("input/day7-example") == 21
  end

  test "day7part2" do
    assert Day7.part2("input/day7-example") == 40
  end
end
