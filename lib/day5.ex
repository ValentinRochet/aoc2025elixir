defmodule Day5 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day5-input") do
    input = File.read!(file)

    [ranges_raw, ingredients] =
      String.split(input, "\r\n\r\n", parts: 2) |> Enum.map(&String.split(&1, "\r\n"))

    ranges =
      ranges_raw
      |> Enum.map(fn r ->
        [first, last] = r |> String.split("-", parts: 2) |> Enum.map(&String.to_integer(&1))
        {first, last}
      end)

    ingredients
    |> Enum.map(&String.to_integer(&1))
    |> Enum.filter(fn i ->
      Enum.any?(ranges, fn {first, last} -> first <= i and i <= last end)
    end)
    |> Enum.count()
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day5-input") do
    input = File.read!(file)

    [ranges_raw, _] =
      String.split(input, "\r\n\r\n", parts: 2) |> Enum.map(&String.split(&1, "\r\n"))

    ranges =
      ranges_raw
      |> Enum.map(fn r ->
        [min, max] = r |> String.split("-", parts: 2) |> Enum.map(&String.to_integer(&1))
        {min, max}
      end)

    ranges
    |> Enum.sort_by(fn {min, _} -> min end)
    |> Enum.reduce([], fn {min, max}, acc ->
      case acc do
        [] ->
          [{min, max}]

        [{last_min, last_max} | rest] ->
          if min <= last_max + 1 do
            [{last_min, max(last_max, max)} | rest]
          else
            [{min, max} | acc]
          end
      end
    end)
    |> Enum.map(fn {min, max} -> max - min + 1 end)
    |> Enum.sum()
  end
end
