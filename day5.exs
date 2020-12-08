defmodule Day5 do
  @input File.stream!("./day5_input.txt")

  @seat_numbers 0..1021

  def part1() do
    seats = get_seats()
    highest_number = highest_seat_number(seats)
    IO.puts("Highest seat number: #{highest_number}")
  end

  def part2() do
    seats = get_seats()
    mine = find_my_seat(seats)
    IO.puts("My seat: #{mine}")
  end

  defp get_seats() do
    @input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&Seat.new/1)
    |> Stream.map(&Seat.find_row/1)
    |> Stream.map(&Seat.find_column/1)
    |> Stream.map(&Seat.find_seat_number/1)
    |> Enum.to_list()
  end

  defp highest_seat_number(seats), do: Enum.reduce(seats, 0, &largest/2)

  defp largest(%Seat{seat_number: seat_number}, current) when seat_number > current, do: seat_number
  defp largest(%Seat{seat_number: seat_number}, current), do: current 

  defp find_my_seat(seats) do
    seats
    |> find_missing_seats()
    |> find_seat_next_to_other_seats(seats)
  end

  defp find_missing_seats(seats), do: Enum.reject(@seat_numbers, fn number -> Enum.any?(seats, &(&1.seat_number == number)) end)

  defp find_seat_next_to_other_seats(missing_seats, all_seats) do
    Enum.find(missing_seats, fn seat ->
      # does all_seats include a seat for seat+1 and seat-1?
      Enum.any?(all_seats, &(seat + 1 == &1.seat_number)) && Enum.any?(all_seats, &(seat - 1 == &1.seat_number))
    end)
  end
end

defmodule Seat do
  alias __MODULE__
  defstruct [:row_chars, :column_chars, :row, :column, :seat_number]

  @total_rows 127
  @total_columns 7

  def new(binary) do
    lst = String.graphemes(binary)
    %Seat{row_chars: Enum.take(lst, 7), column_chars: Enum.take(lst, -3)}
  end

  def find_row(seat) do
    {seat, _} = _find_row(seat)
    seat
  end

  defp _find_row(%Seat{row_chars: row_chars} = seat) do
    Enum.reduce(row_chars, {seat, 0..@total_rows}, fn row, {r, first..last = range} ->
      current_range_size = Enum.count(range)
      half = div(current_range_size, 2)
      middle = half + first

      if row == "F" do
        take_first_half(r, half, first, middle, :row)
      else
        take_last_half(r, half, last, middle, :row)
      end
    end)
  end

  def find_column(seat) do
    {seat, _} = _find_column(seat)
    seat
  end

  defp _find_column(%Seat{column_chars: column_chars} = seat) do
    Enum.reduce(column_chars, {seat, 0..@total_columns}, fn column, {r, first..last = range} ->
      current_range_size = Enum.count(range)
      half = div(current_range_size, 2)
      middle = half + first

      if column == "L" do
        take_first_half(r, half, first, middle, :column)
      else
        take_last_half(r, half, last, middle, :column)
      end
    end)
  end

  defp take_first_half(seat, 1, first, middle, field), do: {add(seat, field, first), first..(middle - 1)}
  defp take_first_half(seat, _half, first, middle, field), do: {seat, first..(middle - 1)}

  defp take_last_half(seat, 1, last, middle, field), do: {add(seat, field, last), middle..last}
  defp take_last_half(seat, half, last, middle, field), do: {seat, middle..last}

  def find_seat_number(%Seat{row: row, column: column} = seat) do
    %{seat | seat_number: row * 8  + column}
  end

  defp add(seat, field, value), do: Map.put(seat, field, value)
end
