defmodule Day3 do
  @input File.stream!("./day3_input.txt")

  defstruct [:col_index, :row_index, :tree_count, :right, :down]
  alias __MODULE__

  def part1() do
    input_data
    |> Enum.reduce(new(3, 1), &reduce/2)
    |> Enum.map(fn %Day3{tree_count: tree_count} -> tree_count end)
    |> IO.inspect(label: "Tree Count")
  end

  def part2() do
    input = input_data()

    [new(1, 1), new(3, 1), new(5, 1), new(7, 1), new(1, 2)]
    |> Enum.map(fn scenario -> Enum.reduce(input, scenario, &reduce/2) end)
    |> Enum.map(fn %Day3{tree_count: count} -> count end)
    |> Enum.reduce(1, fn x, acc -> acc * x end)
    |> IO.inspect(label: "PRODUCT")
  end

  defp new(right, down) do
    %Day3{col_index: 0, row_index: 0, tree_count: 0, right: right, down: down}
  end

  defp input_data() do
    @input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.to_list()
  end

  defp reduce(_, %Day3{col_index: 0} = state), do: %{state | col_index: 1, row_index: state.right}

  defp reduce(_, state) when rem(state.col_index, state.down) > 0,
    do: %{state | col_index: state.col_index + 1}

  defp reduce(current_line, state) do
    index = state.row_index
    char_count = Enum.count(current_line)

    {new_index, tree} = tree_index_value(current_line, index, char_count)

    %{
      state
      | row_index: new_index + state.right,
        tree_count: state.tree_count + tree,
        col_index: state.col_index + 1
    }
  end

  defp tree_index_value(line, index, char_count) when index + 1 > char_count do
    index = index - char_count
    tree = tree_value(line, index)
    {index, tree}
  end

  defp tree_index_value(line, index, char_count), do: {index, tree_value(line, index)}

  defp tree_value(line, index) do
    if Enum.at(line, index) == "#" do
      1
    else
      0
    end
  end
end
