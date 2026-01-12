defmodule Day10 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day10-input") do
    input = File.read!(file)

    machines =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [[_, raw_score]] = Regex.scan(~r/\[([^\]]+)\]/, line)

        score =
          raw_score
          |> String.replace(".", "0")
          |> String.replace("#", "1")
          |> String.to_integer()

        bts_pow_base = String.length(raw_score) - 1

        buttons =
          Regex.scan(~r/\(([^)]+)\)/, line)
          |> Enum.map(fn [_, bts] ->
            generate_buttons(bts, bts_pow_base)
          end)

        {score, buttons}
      end)

    machines
    |> Enum.map(&find_fewest_presses(&1))
    |> Enum.sum()
  end

  defp generate_buttons(raw, bts_pow_base) do
    String.split(raw, ",")
    |> Enum.reduce(0, fn b, acc ->
      acc + trunc(:math.pow(10, bts_pow_base - String.to_integer(b)))
    end)
  end

  defp find_fewest_presses({score, buttons}) do
    generate_all_combinaisons(buttons, [{0, 0}])
    |> Enum.filter(fn {s, _} -> s == score end)
    |> Enum.map(fn {_, t} -> t end)
    |> Enum.min()
  end

  defp generate_all_combinaisons([], scores) do
    scores
  end

  defp generate_all_combinaisons([bt | rest], scores) do
    new_scores =
      scores
      |> Enum.map(fn {s, t} ->
        # Addition chiffre par chiffre modulo 2
        {add_mod2(s, bt), t + 1}
      end)

    generate_all_combinaisons(rest, new_scores ++ scores)
  end

  # Addition de deux nombres, chiffre par chiffre modulo 2
  defp add_mod2(a, b) when a == 0, do: to_01(b)
  defp add_mod2(a, b) when b == 0, do: to_01(a)

  defp add_mod2(a, b) do
    digit_a = rem(a, 10)
    digit_b = rem(b, 10)
    rest_a = div(a, 10)
    rest_b = div(b, 10)

    result_digit = rem(digit_a + digit_b, 2)

    add_mod2(rest_a, rest_b) * 10 + result_digit
  end

  # Convertit un nombre en remplaçant chaque chiffre par 0 si pair, 1 si impair
  defp to_01(0), do: 0

  defp to_01(n) do
    digit = rem(n, 10)
    rest = div(n, 10)
    to_01(rest) * 10 + rem(digit, 2)
  end

  ##
  ## part 2 -- not working : logic is OK but we use too much memory
  ##
  def part2(file \\ "input/day10-input") do
    input = File.read!(file)

    machines = String.split(input, "\r\n")
    IO.puts("Processing #{length(machines)} machines...")

    machines
    |> Enum.with_index(1)
    |> Enum.map(fn {line, idx} ->
      [[_, raw_joltage]] = Regex.scan(~r/\{([^\]]+)\}/, line)

      expected_joltages =
        raw_joltage
        |> String.split(",")
        |> Enum.with_index()
        |> Enum.map(fn {j, p} -> {p, String.to_integer(j)} end)
        |> Map.new()

      IO.inspect(expected_joltages, label: "Testing joltage : ")

      buttons =
        Regex.scan(~r/\(([^)]+)\)/, line)
        |> Enum.map(fn [_, bts] ->
          bts
          |> String.split(",")
          |> Enum.map(&String.to_integer(&1))
        end)

      initial_joltages = Map.new(expected_joltages, fn {k, _} -> {k, 0} end)

      result =
        Enum.reduce_while(1..1000, [initial_joltages], fn t, acc ->
          IO.write(".")

          new_joltages =
            acc
            |> Enum.flat_map(fn a ->
              Enum.map(buttons, fn b -> update_joltages(a, b) end)
            end)
            |> Enum.uniq()
            |> Enum.filter(fn j ->
              Enum.all?(j, fn {key, value} ->
                value <= Map.get(expected_joltages, key)
              end)
            end)

          cond do
            Enum.any?(new_joltages, fn j -> j == expected_joltages end) ->
              {:halt, t}

            Enum.empty?(new_joltages) ->
              {:halt, :impossible}

            true ->
              {:cont, new_joltages}
          end
        end)

      IO.puts("")
      IO.puts("Machine #{idx}: #{result} presses")
      result
    end)
    |> Enum.sum()
  end

  defp update_joltages(map, buttons) do
    buttons
    |> Enum.reduce(map, fn b, acc ->
      Map.update(acc, b, 1, fn j -> j + 1 end)
    end)
  end
end
