defmodule Day11 do
  ##
  ## part 1
  ##
  def part1(file \\ "input/day11-input") do
    input = File.read!(file)

    config =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [device, outputs] = String.split(line, ": ", parts: 2)
        {device, String.split(outputs, " ")}
      end)

    build_all_exit_paths(config, ["you"])
    |> List.flatten()
    |> Enum.sum()
  end

  defp build_all_exit_paths(config, currentPath) do
    config
    |> Enum.filter(fn {name, _} -> name == hd(currentPath) end)
    |> Enum.flat_map(fn {_, devices} -> devices end)
    |> Enum.map(fn device ->
      if device == "out" do
        1
      else
        if Enum.any?(currentPath, fn d -> d == device end) do
          0
        else
          build_all_exit_paths(config, [device] ++ currentPath)
        end
      end
    end)
  end

  ##
  ## part 2
  ##
  def part2(file \\ "input/day11-input") do
    input = File.read!(file)

    config =
      input
      |> String.split("\r\n")
      |> Enum.map(fn line ->
        [device, outputs] = String.split(line, ": ", parts: 2)
        {device, String.split(outputs, " ")}
      end)
      |> Map.new()

    {result, _cache} = explore_tree("svr", false, false, config, %{})
    result
  end

  defp explore_tree("out", true, true, _, cache) do
    {1, cache}
  end

  defp explore_tree("out", _, _, _, cache) do
    {0, cache}
  end

  defp explore_tree(device, found_fft, found_dac, config, cache) do
    key = {device, found_fft, found_dac}

    case Map.get(cache, key) do
      nil ->
        {total, cache} =
          Map.get(config, device)
          |> Enum.reduce({0, cache}, fn d, {acc, cache} ->
            {count, cache} =
              explore_tree(d, found_fft or d == "fft", found_dac or d == "dac", config, cache)

            {acc + count, cache}
          end)

          dbg(cache)

        {total, Map.put(cache, key, total)}

      cached ->
        {cached, cache}
    end
  end
end
