defmodule Day2 do

  alias __MODULE__

  defstruct [:low_end, :high_end, :letter, :password]

  def run1() do
    get_data()
    |> Stream.filter(&valid_password1/1)
    |> Enum.to_list()
    |> Enum.count()
  end

  def run2() do
    get_data()
    |> Stream.filter(&valid_password2/1)
    |> Enum.to_list
    |> Enum.count
  end

  defp get_data() do
    "./day2_input.txt"
    |> File.stream!()
    |> Stream.map(fn line -> 
      [range, letter, password] = String.split(line, " ")
      [low, high] = String.split(range, "-")
      %Day2{low_end: to_int(low), high_end: to_int(high), password: String.trim(password), letter: String.trim(letter, ":")}
    end)
  end

  defp valid_password1(password_data) do
    count =
      password_data.password
      |> String.graphemes()
      |> Enum.reject(&(&1 != password_data.letter))
      |> Enum.count()
    count >= password_data.low_end && count <= password_data.high_end
  end

  defp valid_password2(password_data) do
    letters = password_data.password |> String.graphemes()
    low = password_data.low_end - 1
    high = password_data.high_end - 1
    low_end_exists = Enum.at(letters, low) == password_data.letter
    high_end_exists = Enum.at(letters, high) == password_data.letter 

    if low_end_exists && high_end_exists do
      false
    else
      low_end_exists || high_end_exists
    end
  end

  defp to_int(str), do: String.to_integer(str)
end
