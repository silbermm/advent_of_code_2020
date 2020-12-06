defmodule Day4 do
  @input File.stream!("./day4_input.txt")

  def part1() do
    valid_passports =
      get_passports_from_file()
      |> get_valid_passports()

    IO.puts("Part 1: #{Enum.count(valid_passports)} Valid Passports")
  end

  def part2() do
    valid_passports =
      get_passports_from_file()
      |> get_valid_passports()
      |> Enum.filter(&Passport.fields_valid?/1)

    IO.puts("Part 2: #{Enum.count(valid_passports)} Valid Passports")
  end

  defp get_passports_from_file() do
    @input
    |> map_each_chunk()
    |> to_passports()
  end

  defp get_valid_passports(all_passports) do
    all_passports
    |> Enum.filter(&Passport.has_required_fields?/1)
  end

  defp to_passports(str_list) do
    Enum.map(str_list, &Passport.new/1)
  end

  defp map_each_chunk(stream) do
    {lines, _} = Enum.reduce(stream, {[], []}, &line_reducer/2)
    lines
  end

  defp line_reducer("\n", {acc, str_acc}), do: {[str_acc | acc], ""}
  defp line_reducer(line, {acc, ""}), do: {acc, String.trim(line)}

  defp line_reducer(line, {acc, str_acc}) do
    str_acc = "#{str_acc} #{String.trim(line)}"
    {acc, str_acc}
  end
end

defmodule Passport do
  alias __MODULE__

  defstruct [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]

  @required_fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]

  def new(str) do
    initial = %Passport{}

    str
    |> String.trim()
    |> String.split(" ")
    |> Enum.reduce(initial, &add_field/2)
  end

  def has_required_fields?(passport) do
    invalid = Enum.any?(@required_fields, fn f -> Map.get(passport, f, nil) == nil end)
    !invalid
  end

  def fields_valid?(passport) do
    boolean_list =
      for {key, value} <- Map.from_struct(passport) do
        valid?(key, value)
      end

    Enum.all?(boolean_list, & &1)
  end

  defp valid?(:pid, pid), do: String.length(pid) == 9 && Integer.parse(pid) != :error
  defp valid?(:byr, byr), do: between(byr, 1920, 2002)
  defp valid?(:iyr, iyr), do: between(iyr, 2010, 2020)
  defp valid?(:eyr, eyr), do: between(eyr, 2020, 2030)
  defp valid?(:hgt, hgt), do: valid_height?(String.reverse(hgt))
  defp valid?(:hcl, <<"#" <> chars>>), do: String.length(chars) == 6
  defp valid?(:hcl, _), do: false
  defp valid?(:ecl, "amb"), do: true
  defp valid?(:ecl, "blu"), do: true
  defp valid?(:ecl, "brn"), do: true
  defp valid?(:ecl, "gry"), do: true
  defp valid?(:ecl, "grn"), do: true
  defp valid?(:ecl, "hzl"), do: true
  defp valid?(:ecl, "oth"), do: true
  defp valid?(:ecl, _), do: false
  defp valid?(_, _), do: true

  defp add_field("pid:" <> value, passport), do: %{passport | pid: value}
  defp add_field("cid:" <> value, passport), do: %{passport | cid: value}
  defp add_field("byr:" <> value, passport), do: %{passport | byr: value}
  defp add_field("iyr:" <> value, passport), do: %{passport | iyr: value}
  defp add_field("eyr:" <> value, passport), do: %{passport | eyr: value}
  defp add_field("hgt:" <> value, passport), do: %{passport | hgt: value}
  defp add_field("hcl:" <> value, passport), do: %{passport | hcl: value}
  defp add_field("ecl:" <> value, passport), do: %{passport | ecl: value}

  # Here we reversed the string so we can match the begining with a valid prefix `mc` (cm) or `ni` (in)
  defp valid_height?(<<"mc" <> number>>) do
    original_number = String.reverse(number)
    between(original_number, 150, 193)
  rescue
    _e in ArgumentError -> false
  end

  defp valid_height?(<<"ni" <> number>>) do
    original_number = String.reverse(number)
    between(original_number, 59, 76)
  rescue
    _e in ArgumentError -> false
  end

  defp valid_height?(_), do: false

  defp between(str, low, high) do
    number = String.to_integer(str)
    number >= low && number <= high
  rescue
    _e in ArgumentError -> false
  end
end
