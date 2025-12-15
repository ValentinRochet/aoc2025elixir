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
      {n, ""} -> n
      _ -> txt
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day6-input") do
    input = File.read!(file)

    input
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes(&1))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.reduce({[:add], 0}, fn row, {current_operation, total} ->
      {numbers, [ope]} = Enum.split(row, -1)

      case ope do
        " " -> {current_operation ++ [numbers], total}
        "+" -> {[:add, numbers], total + execute_operation(current_operation)}
        "*" -> {[:mult, numbers], total + execute_operation(current_operation)}
      end
    end)
    |> then(fn {last_operation, total} -> total + execute_operation(last_operation) end)
  end

  defp execute_operation([ope | numbers_raw]) do
    numbers =
      numbers_raw
      |> Enum.map(fn n -> n |> Enum.join() |> String.trim() end)
      |> Enum.filter(fn n -> n != "" end)
      |> Enum.map(&String.to_integer(&1))

    case ope do
      :add -> Enum.sum(numbers)
      :mult -> Enum.product(numbers)
    end
  end
end
