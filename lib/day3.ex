defmodule Day3 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day3-input") do
    input = File.read!(file)

    input
    |> String.split("\r\n")
    |> Enum.map(fn bank ->
      first_joltage = get_max_joltage(elem(String.split_at(bank, String.length(bank) - 1), 0))

      [_, rest] = String.split(bank, Integer.to_string(first_joltage), parts: 2)

      second_joltage = get_max_joltage(rest)

      first_joltage * 10 + second_joltage
    end)
    |> Enum.sum()
  end

  defp get_max_joltage(bank, searching \\ 9) do
    if String.contains?(bank, Integer.to_string(searching)) do
      searching
    else
      get_max_joltage(bank, searching - 1)
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day3-input") do
    input = File.read!(file)

    input
    |> String.split("\r\n")
    |> Enum.map(fn bank ->
      get_total_joltage_part_2(bank, 0, 12)
    end)
    |> Enum.sum()
  end

  defp get_total_joltage_part_2(_, score, batt_to_add) when batt_to_add == 0 do
    score
  end

  defp get_total_joltage_part_2(bank, score, batt_to_add) do
    j = get_max_joltage(elem(String.split_at(bank, String.length(bank) - batt_to_add + 1), 0))

    [_, rest] = String.split(bank, Integer.to_string(j), parts: 2)

    local_score = :math.pow(10, batt_to_add - 1) * j

    get_total_joltage_part_2(rest, score + local_score, batt_to_add - 1)
  end
end
