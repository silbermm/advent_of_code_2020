defmodule Day3 do
  @input File.stream!("./day3_input.txt")

  def part1() do
    @input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.to_list()
    |> Enum.reduce({0, 0}, fn x, {current_list_index, current_tree_count} ->
      nil
      # if current_list_index is 0 - go to next line
    end)
  end
end
