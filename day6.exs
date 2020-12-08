defmodule Day6 do
  @input File.stream!("./day6_input.txt")

  def part1() do
    groups = get_groups()
    unique = unique_answers_per_group(groups)
    counts = number_of_answers_per_group(unique)
    IO.puts("Sum of all answers: #{Enum.sum(counts)}")
  end

  def part2() do
    groups = get_group_lists()
    numbers = Enum.map(groups, &number_of_same_answers/1)
    IO.puts("Sum of all answers: #{Enum.sum(numbers)}")
  end

  def get_group_lists() do
    @input
    |> map_each_chunk_as_list()
  end

  def get_groups() do
    @input
    |> map_each_chunk()
    |> build_lists()
  end

  defp number_of_same_answers(group) do
    number_of_groups = Enum.count(group)

    {dups, _} =
      if number_of_groups == 1 do
        {List.flatten(group), 0}
      else
        Enum.reduce(group, {[], 0}, fn x, {current_dups, index} ->
          lsts = group_list_except(group, index)

          letters =
            for letter <- x do
              # is letter in all of the other lsts?
              in_all? =
                Enum.all?(lsts, fn char_lst ->
                  Enum.member?(char_lst, letter)
                end)

              if in_all? do
                letter
              else
                nil
              end
            end

          {letters ++ current_dups, index + 1}
        end)
      end

    dups
    |> Enum.reject(&(&1 == nil))
    |> Enum.uniq()
    |> Enum.count()
  end

  defp group_list_except(group, index) do
    group
    |> Enum.with_index()
    |> Enum.filter(fn {_el, idx} -> idx != index end)
    |> Enum.map(fn {el, _idx} -> el end)
  end

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

  defp map_each_chunk_as_list(stream) do
    Enum.reduce(stream, {[], []}, &list_reducer/2)
  end

  defp list_reducer("\n", {lst, str}), do: {[str | lst], []}
  defp list_reducer(line, {lst, ""}), do: {lst, String.trim(line)}

  defp list_reducer(line, {lst, str}) do
    str_acc = [String.graphemes(String.trim(line)) | str]
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
