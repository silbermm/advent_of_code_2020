defmodule Day7 do
  @input File.stream!("./day7_input.txt")

  def part1() do
    @input
    |> Stream.map(&Bag.new/1)
  end
end

defmodule Bag do
  alias __MODULE__

  defstruct [:name, :quantity, :bags]

  def new

  def new(str) do
    [bag, others] =
      str
      |> String.trim()
      |> String.split(" bags contain ")

    %Bag{name: bag, quantity: 1, bags: Bag.new(String.split(bags, ", "))}
  end
end
