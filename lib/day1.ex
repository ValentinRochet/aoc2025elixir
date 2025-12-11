defmodule Day1 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day1-input") do
    input = File.read!(file)

    instructions =
      input
      |> String.split("\r\n")
      |> Enum.map(fn instr ->
        {dir, times} = String.split_at(instr, 1)
        {dir, String.to_integer(times)}
      end)

    rotate(instructions)
  end

  defp rotate(instr, pos \\ 50)

  defp rotate([], _) do
    0
  end

  defp rotate([{d, t} | rest], pos) do
    new_pos =
      if d == "L" do
        rem(pos - t, 100)
      else
        rem(pos + t, 100)
      end

    if new_pos == 0 do
      1 + rotate(rest, new_pos)
    else
      0 + rotate(rest, new_pos)
    end
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day1-input") do
    input = File.read!(file)

    instructions =
      input
      |> String.split("\r\n")
      |> Enum.map(fn instr ->
        {dir, times} = String.split_at(instr, 1)
        {dir, String.to_integer(times)}
      end)

    rotate_part_2(instructions)
  end

  defp rotate_part_2(instr, pos \\ 50)

  defp rotate_part_2([], _) do
    0
  end

  defp rotate_part_2([{d, t} | rest], pos) do
    s1 = div(t, 100)

    new_pos =
      if d == "L" do
        pos - rem(t, 100)
      else
        pos + rem(t, 100)
      end

    {s2, final_pos} = normalize_pos(pos, new_pos)

    s1 + s2 + rotate_part_2(rest, final_pos)
  end

  defp normalize_pos(prev_pos, pos) when pos < 0 and prev_pos > 0 do
    {1, pos + 100}
  end

  defp normalize_pos(prev_pos, pos) when pos < 0 and prev_pos == 0 do
    {0, pos + 100}
  end

  defp normalize_pos(_, pos) when pos >= 100 do
    {1, pos - 100}
  end

  defp normalize_pos(_, pos) when pos == 0 do
    {1, pos}
  end

  defp normalize_pos(_, pos) do
    {0, pos}
  end
end
