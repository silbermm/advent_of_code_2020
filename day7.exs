defmodule Day7 do
  @input File.stream!("./day7_input.txt")

  def part1() do
    bags =
      @input
      |> Stream.map(&Bag.new/1)
      |> Enum.to_list
      |> filter()

    IO.puts "Number of bags that can hold a gold bag is #{Enum.count(bags)}"
  end

  defp filter(bags) do
    Enum.filter(bags, fn b -> Bag.can_contain?(b, "shiny gold", bags) end)
  end

  def part2() do
    bags =
      @input
      |> Stream.map(&Bag.new/1)
      |> Enum.to_list

    {shiny_gold, all_others} = Bag.get(bags, "shiny gold")
    Bag.count_required(shiny_gold, all_others)
  end
end

defmodule Bag do
  alias __MODULE__

  defstruct [:name, :quantity, :bags]

  def new(lst) when is_list(lst) do
    lst
    |> Enum.map(&new_from_list/1)
    |> Enum.reject(fn x -> x == nil end)
  end

  defp new_from_list("no other bags"), do: nil
  defp new_from_list(bag) do
    [number, adj, color, _] = String.split(bag, " ")
    %Bag{name: "#{adj} #{color}", quantity: number, bags: []}
  end

  def new(str) do
    [bag, others] =
      str
      |> String.trim()
      |> String.trim(".")
      |> String.split(" bags contain ")

    %Bag{name: bag, quantity: 1, bags: Bag.new(String.split(others, ", "))}
  end

  def get(bags, name) do
    res = Enum.find(bags, fn b -> b.name == name end)
    {res, Enum.reject(bags, fn b -> b.name == name end)}
  end

  def count_required(bag, all_bags) do
    _count_required(bag.bags, all_bags, 0)
  end
  
  defp _count_required([], all, count) do
    count
  end

  defp _count_required([current | rest], all, count) do
  end

  def can_contain?(bag, color, all_bags) do
    directly = Enum.find(bag.bags, fn b -> b.name == color end)
    empty? = Enum.empty?(bag.bags)
    if directly do
      true
    else
      if empty? do
        false
      else 
        if Enum.find(bag.bags, fn b -> _can_contain(b, color, all_bags) end) == nil do
          false
        else 
          true
        end
      end
    end
  end

  defp _can_contain(bag, color, all_bags) do
    # get bag rule from all_bags
    if bag.name == color do 
      true
    else
      {bag_rule, rest} = Bag.get(all_bags, bag.name)
      if bag_rule == nil do false else Bag.can_contain?(bag_rule, color, rest) end
    end
  end
end
