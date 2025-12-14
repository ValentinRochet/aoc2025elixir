defmodule Day6 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day6-input") do
    input = File.read!(file)

    input
    |> String.split("\r\n")
    |> Enum.map(fn line ->
      line
      |> String.replace(~r/ +/, " ")
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&to_integer_else(&1))
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn row ->
      {numbers, [ope]} = Enum.split(row, -1)
      case ope do
        "+" -> Enum.sum(numbers)
        "*" -> Enum.product(numbers)
      end
    end)
    |> Enum.sum()
  end

  def to_integer_else(txt) do
    case Integer.parse(txt) do
      {_, ""} -> String.to_integer(txt)
      _ -> txt
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day6-input") do
    _input = File.read!(file)
  end
end
