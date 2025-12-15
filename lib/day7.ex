defmodule Day7 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day7-input") do
    input = File.read!(file)

    [first_line | rest_line] =
      input
      |> String.split("\r\n")

    {start_position, _} = :binary.match(first_line, "S")

    {_beams, splits} =
      rest_line
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {c, _} -> c == "^" end)
        |> Enum.map(fn {_, pos} -> pos end)
      end)
      |> Enum.reduce({[start_position], 0}, fn splitters, {beams, splits} ->
        new_beams =
          beams
          |> Enum.flat_map(fn b ->
            if Enum.any?(splitters, fn s -> s == b end) do
              [b - 1, b + 1]
            else
              [b]
            end
          end)

        {Enum.uniq(new_beams), splits + length(new_beams) - length(beams)}
      end)

    splits
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day7-input") do
    input = File.read!(file)

    [first_line | rest_line] =
      input
      |> String.split("\r\n")

    {start_position, _} = :binary.match(first_line, "S")

    rest_line
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {c, _} -> c == "^" end)
      |> Enum.map(fn {_, pos} -> pos end)
    end)
    |> Enum.reduce(Map.new([{start_position, 1}]), fn splitters, beams ->
      splitters
      |> Enum.reduce(beams, fn s, acc_beams ->
        if Map.has_key?(acc_beams, s) do
          beam_count = Map.get(acc_beams, s)

          acc_beams
          |> add_beam(beam_count, s - 1)
          |> add_beam(beam_count, s + 1)
          |> Map.delete(s)
        else
          acc_beams
        end
      end)
    end)
    |> Map.values()
    |> Enum.sum()
  end

  defp add_beam(beams, number, position) do
    if Map.has_key?(beams, position) do
      Map.put(beams, position, Map.get(beams, position) + number)
    else
      Map.put(beams, position, number)
    end
  end
end
