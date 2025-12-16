defmodule Day8 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day8-input", nb_connections \\ 1000) do
    input = File.read!(file)

    boxes =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.map(fn {line, i} ->
        [x, y, z] = String.split(line, ",", parts: 3) |> Enum.map(&String.to_integer(&1))
        {i, {x, y, z}}
      end)

    circuits =
      calculate_all_distances(boxes, [])
      |> Enum.sort_by(fn {d, _, _} -> d end)
      |> Enum.take(nb_connections)
      |> Enum.reduce([], fn {_, a, b}, acc ->
        # si a et b dans les tableaux -> on joint les tableaux (attention si meme tableau bien faire un Enum.uniq())
        # si a ou b dans un tableau -> ajouter a et b au tableau en question puis faire un Enum.uniq()
        # si ni a ni b, ajouter nouveau tableau avec a et b

        case {circuits_contains_value?(acc, a), circuits_contains_value?(acc, b)} do
          {true, true} -> join_boxes(acc, a, b)
          {true, false} -> add_new_box_to(acc, b, a)
          {false, true} -> add_new_box_to(acc, a, b)
          {false, false} -> acc ++ [[a, b]]
        end
      end)

    circuits
    |> Enum.map(&length(&1))
    |> Enum.sort_by(& &1)
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, fn score, acc -> acc * score end)
  end

  defp calculate_all_distances([], distances) do
    distances
  end

  defp calculate_all_distances(boxes, distances) do
    [{i1, {x1, y1, z1}} | rest_box] = boxes

    new_distances =
      rest_box
      |> Enum.map(fn {i2, {x2, y2, z2}} ->
        d = :math.sqrt(:math.pow(x1 - x2, 2) + :math.pow(y1 - y2, 2) + :math.pow(z1 - z2, 2))
        {d, i1, i2}
      end)

    calculate_all_distances(rest_box, distances ++ new_distances)
  end

  defp join_boxes(circuits, box_1, box_2) do
    c1 = Enum.find(circuits, fn boxes -> Enum.any?(boxes, fn b -> b == box_1 end) end)

    c2 = Enum.find(circuits, fn boxes -> Enum.any?(boxes, fn b -> b == box_2 end) end)

    [Enum.uniq(c1 ++ c2)] ++
      Enum.reject(circuits, fn boxes ->
        Enum.any?(boxes, fn b -> b == box_1 or b == box_2 end)
      end)
  end

  defp add_new_box_to(circuits, new_box, to_box) do
    circuits
    |> Enum.reduce([], fn boxes, acc ->
      case Enum.any?(boxes, fn b -> b == to_box end) do
        true -> acc ++ [boxes ++ [new_box]]
        false -> acc ++ [boxes]
      end
    end)
  end

  defp circuits_contains_value?(array, value) do
    array
    |> Enum.flat_map(& &1)
    |> Enum.any?(fn i -> i == value end)
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day8-input") do
    input = File.read!(file)

    boxes =
      input
      |> String.split("\r\n")
      |> Enum.with_index()
      |> Enum.map(fn {line, i} ->
        [x, y, z] = String.split(line, ",", parts: 3) |> Enum.map(&String.to_integer(&1))
        {i, {x, y, z}}
      end)

    max_size = length(boxes)

    {last_box_1, last_box_2} =
      calculate_all_distances(boxes, [])
      |> Enum.sort_by(fn {d, _, _} -> d end)
      |> Enum.reduce_while({[], -1, -1}, fn {_, a, b}, acc ->
        {circuits, last_joined_1, last_join_2} = acc

        if length(circuits) > 0 and hd(circuits) |> length() == max_size do
          {:halt, {last_joined_1, last_join_2}}
        else
          new_circuits =
            case {circuits_contains_value?(circuits, a), circuits_contains_value?(circuits, b)} do
              {true, true} -> join_boxes(circuits, a, b)
              {true, false} -> add_new_box_to(circuits, b, a)
              {false, true} -> add_new_box_to(circuits, a, b)
              {false, false} -> circuits ++ [[a, b]]
            end

          {:cont, {new_circuits, a, b}}
        end
      end)

    boxes
    |> Enum.filter(fn {i, _} -> i == last_box_1 or i == last_box_2 end)
    |> Enum.map(fn {_, {x, _, _}} -> x end)
    |> Enum.reduce(1, fn x, acc -> acc * x end)
  end
end
