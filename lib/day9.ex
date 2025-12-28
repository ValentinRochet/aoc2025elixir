defmodule Day9 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day9-input") do
    input = File.read!(file)

    tiles =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [x, y] = line |> String.split(",", parts: 2) |> Enum.map(&String.to_integer(&1))
        {x, y}
      end)

    get_biggest_rectangle(tiles, 0)
  end

  defp get_biggest_rectangle([_], biggest_rectangle) do
    biggest_rectangle
  end

  defp get_biggest_rectangle([{x1, y1} | rest_tiles], biggest_rectangle) do
    new_max_rectangle =
      rest_tiles
      |> Enum.reduce(biggest_rectangle, fn {x2, y2}, acc ->
        rectangle = (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
        max(acc, rectangle)
      end)

    get_biggest_rectangle(rest_tiles, new_max_rectangle)
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day9-input") do
    input = File.read!(file)

    red_tiles =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [x, y] = line |> String.split(",", parts: 2) |> Enum.map(&String.to_integer(&1))
        {x, y}
      end)

    ordered_rectangles_with_size =
      get_all_rectangles_with_size(red_tiles, [])
      |> Enum.sort_by(fn {_, _, size} -> size end)
      |> Enum.reverse()

    perimeter_tiles = get_perimeter(red_tiles)

    {_, _, size} = search_for_valid_rectangle(ordered_rectangles_with_size, perimeter_tiles)
    size
  end

  defp get_all_rectangles_with_size([_], rectangles) do
    rectangles
  end

  defp get_all_rectangles_with_size([{x1, y1} | rest_tiles], rectangles) do
    curr_rectangles =
      rest_tiles
      |> Enum.map(fn {x2, y2} ->
        size = (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
        {{x1, y1}, {x2, y2}, size}
      end)

    # Utiliser [head | tail] au lieu de tail ++ [head] = O(1) au lieu de O(n)
    get_all_rectangles_with_size(rest_tiles, curr_rectangles ++ rectangles)
  end

  defp get_perimeter(red_tiles) do
    # Nettoyer les segments adjacents avant de construire le périmètre
    cleaned_tiles = remove_adjacent_segments(red_tiles)
    first_tile = hd(cleaned_tiles)
    perimeter = build_perimeter(cleaned_tiles, first_tile, [])

    perimeter |> Enum.uniq() |> MapSet.new()
  end

  # Supprime les segments qui font un aller-retour (côte à côte)
  defp remove_adjacent_segments(tiles) when length(tiles) < 3, do: tiles

  defp remove_adjacent_segments(tiles) do
    # Créer une liste circulaire pour vérifier le dernier avec le premier
    circular_tiles = tiles ++ [hd(tiles), Enum.at(tiles, 1)]

    result = check_and_remove_adjacent(circular_tiles, [])

    # Si on a supprimé des segments, réessayer (cas récursifs)
    if length(result) < length(tiles) and length(result) >= 3 do
      remove_adjacent_segments(result)
    else
      result
    end
  end

  defp check_and_remove_adjacent([p1, p2, p3, p4 | rest], acc) do
    if are_segments_adjacent(p1, p2, p3, p4) do
      # Ignorer p2 et p3, continuer avec p1, p4
      check_and_remove_adjacent([p1, p4 | rest], acc)
    else
      # Garder p1, continuer avec le reste
      check_and_remove_adjacent([p2, p3, p4 | rest], acc ++ [p1])
    end
  end

  defp check_and_remove_adjacent([p1, p2, _p3], acc) do
    # Fin de la liste circulaire, on a déjà traité tous les points
    acc ++ [p1, p2]
  end

  defp check_and_remove_adjacent(_, acc), do: acc

  # Vérifie si deux segments consécutifs sont adjacents (parallèles et à distance 1)
  defp are_segments_adjacent({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}) do
    # Segment 1: p1→p2, Segment 2: p3→p4
    # Vérifier s'ils sont parallèles
    seg1_horizontal = y1 == y2
    seg2_horizontal = y3 == y4
    seg1_vertical = x1 == x2
    seg2_vertical = x3 == x4

    cond do
      # Les deux segments sont verticaux et adjacents horizontalement
      seg1_vertical and seg2_vertical and abs(x1 - x3) == 1 ->
        # Vérifier qu'ils se chevauchent en Y
        min_y1 = min(y1, y2)
        max_y1 = max(y1, y2)
        min_y2 = min(y3, y4)
        max_y2 = max(y3, y4)

        # Il y a un chevauchement si les ranges se touchent
        not (max_y1 < min_y2 or max_y2 < min_y1)

      # Les deux segments sont horizontaux et adjacents verticalement
      seg1_horizontal and seg2_horizontal and abs(y1 - y3) == 1 ->
        # Vérifier qu'ils se chevauchent en X
        min_x1 = min(x1, x2)
        max_x1 = max(x1, x2)
        min_x2 = min(x3, x4)
        max_x2 = max(x3, x4)

        # Il y a un chevauchement si les ranges se touchent
        not (max_x1 < min_x2 or max_x2 < min_x1)

      true ->
        false
    end
  end

  defp build_perimeter([{x1, y1}], {x2, y2}, perimeter_acc) do
    perimeter_tiles = get_tiles_between(x1, x2, y1, y2)

    perimeter_tiles ++ perimeter_acc
  end

  defp build_perimeter([{x1, y1} | rest_tile], first_tile, perimeter_acc) do
    {x2, y2} = hd(rest_tile)

    perimeter_tiles = get_tiles_between(x1, x2, y1, y2)

    build_perimeter(
      rest_tile,
      first_tile,
      perimeter_acc ++ perimeter_tiles
    )
  end

  defp get_tiles_between(x1, x2, y1, y2) do
    for x <- min(x1, x2)..max(x1, x2), y <- min(y1, y2)..max(y1, y2) do
      {x, y}
    end
  end

  defp search_for_valid_rectangle([rectangle], _perimeter_tiles) do
    rectangle
  end

  defp search_for_valid_rectangle([rectangle | rest_rectangle], perimeter_tiles) do
    IO.inspect(rectangle, label: "Testing rectangle")

    if is_rectangle_valid(rectangle, perimeter_tiles) do
      rectangle
    else
      search_for_valid_rectangle(rest_rectangle, perimeter_tiles)
    end
  end

  # Vérifie si le rectangle ne contient aucun point du périmètre à l'intérieur
  defp is_rectangle_valid({{x1, y1}, {x2, y2}, _}, perimeter_tiles) do
    min_rect_x = min(x1, x2)
    max_rect_x = max(x1, x2)
    min_rect_y = min(y1, y2)
    max_rect_y = max(y1, y2)

    # Vérifier si un point du périmètre est strictement à l'intérieur du rectangle
    # (pas sur les bords, mais à l'intérieur)
    has_perimeter_inside =
      Enum.any?(perimeter_tiles, fn {px, py} ->
        px > min_rect_x and px < max_rect_x and py > min_rect_y and py < max_rect_y
      end)

    # Le rectangle est valide si aucun point du périmètre n'est à l'intérieur
    not has_perimeter_inside
  end
end
