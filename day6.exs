defmodule Day6 do
  @input File.stream!("./day6_input.txt")

  def part1() do
    groups = get_groups()
    unique = unique_answers_per_group(groups)
    counts = number_of_answers_per_group(unique)
    IO.puts("Sum of all answers: #{Enum.sum(counts)}")
  end

  def part2() do
    {groups, _} = get_group_sets()
    numbers = Enum.map(groups, &number_of_same_answers/1)
    IO.puts("Sum of all answers: #{Enum.sum(numbers)}")
  end

  def get_group_sets() do
    @input
    |> map_each_chunk_as_sets()
  end

  def get_groups() do
    @input
    |> map_each_chunk()
    |> build_lists()
  end

  defp number_of_same_answers(group) do
    group
    |> Enum.reduce(nil, &find_intersection/2)
    |> Enum.count()
  end

  defp find_intersection(mapset, nil), do: mapset

  defp find_intersection(current_mapset, matched_mapset),
    do: MapSet.intersection(current_mapset, matched_mapset)

  defp unique_answers_per_group(groups) do
    Enum.map(groups, &Enum.uniq/1)
  end

  defp number_of_answers_per_group(groups) do
    Enum.map(groups, &Enum.count/1)
  end

  defp build_lists(strings) do
    strings
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
  end

  defp map_each_chunk_as_sets(stream) do
    Enum.reduce(stream, {[], []}, &list_reducer/2)
  end

  defp list_reducer("\n", {lst, str}), do: {[str | lst], []}
  defp list_reducer(line, {lst, ""}), do: {lst, String.trim(line)}

  defp list_reducer(line, {lst, str}) do
    set =
      line
      |> String.trim()
      |> String.graphemes()
      |> MapSet.new()

    str_acc = [set | str]
    {lst, str_acc}
  end

  defp map_each_chunk(stream) do
    Enum.reduce(stream, {[], []}, &line_reducer/2)
  end

  defp line_reducer("\n", {lst, str}), do: {[str | lst], ""}
  defp line_reducer(line, {lst, ""}), do: {lst, String.trim(line)}

  defp line_reducer(line, {lst, str}) do
    str_acc = "#{str}#{String.trim(line)}"
    {lst, str_acc}
  end
end
