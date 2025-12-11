defmodule Day4 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day4-input") do
    input = File.read!(file)

    grid =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {c, _} -> c == "@" end)
        |> Enum.map(fn {_, x} ->
          {x, y}
        end)
      end)

    grid
    |> Enum.filter(fn {x, y} ->
      adj_rolls =
        get_adjacent(x, y)
        |> Enum.filter(fn {x, y} ->
          grid |> Enum.any?(fn {a, b} -> a == x and b == y end)
        end)
        |> Enum.count()

      adj_rolls < 4
    end)
    |> Enum.count()
  end

  defp get_adjacent(x, y) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day4-input") do
    input = File.read!(file)

    grid =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.filter(fn {c, _} -> c == "@" end)
        |> Enum.map(fn {_, x} ->
          {x, y}
        end)
      end)

    length(grid) - clean_grid(grid)
  end

  defp clean_grid(grid) do
    IO.puts("Size of grid : #{length(grid)}")

    grid_removed =
      grid
      |> Enum.filter(fn {x, y} ->
        adj_rolls =
          get_adjacent(x, y)
          |> Enum.filter(fn {x, y} ->
            grid |> Enum.any?(fn {a, b} -> a == x and b == y end)
          end)
          |> Enum.count()

        adj_rolls >= 4
      end)

    if length(grid) == length(grid_removed) do
      length(grid)
    else
      clean_grid(grid_removed)
    end
  end
end
