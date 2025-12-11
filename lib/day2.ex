defmodule Day2 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day2-input") do
    input = File.read!(file)

    input
    |> String.split(",")
    |> Enum.map(fn r ->
      [first, last] = String.split(r, "-", parts: 2)
      check_range(String.to_integer(first), String.to_integer(last), 0)
    end)
    |> Enum.sum()
  end

  defp check_range(number, last, score) when number > last do
    score
  end

  defp check_range(number, last, score) do
    new_score =
      if is_number_repeated(number) do
        score + number
      else
        score
      end

    check_range(number + 1, last, new_score)
  end

  defp is_number_repeated(number) do
    if rem(length(Integer.digits(number)), 2) == 1 do
      false
    else
      division = trunc(:math.pow(10, length(Integer.digits(number)) / 2))
      Integer.floor_div(number, division) == rem(number, division)
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day2-input") do
    input = File.read!(file)

    input
    |> String.split(",")
    |> Enum.map(fn r ->
      [first, last] = String.split(r, "-", parts: 2)
      dbg({first, last})
      check_range_part_2(String.to_integer(first), String.to_integer(last), 0)
    end)
    |> Enum.sum()
  end

  defp check_range_part_2(number, last, score) when number > last do
    score
  end

  defp check_range_part_2(number, last, score) do
    new_score =
      if is_number_repeated_part_2("", Integer.to_string(number)) do
        dbg(number)
        score + number
      else
        score
      end

    check_range_part_2(number + 1, last, new_score)
  end

  defp is_number_repeated_part_2(first, last) do
    if String.length(last) < 2 or String.length(first) > String.length(last) do
      false
    else
      {char, rest} = String.split_at(last, 1)
      pattern = first <> char

      if String.match?(rest, ~r/^(#{pattern}){1,}$/) do
        true
      else
        is_number_repeated_part_2(pattern, rest)
      end
    end
  end
end
