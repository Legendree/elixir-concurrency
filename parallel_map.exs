defmodule Parallel do
  def map(collection, fun) do
    me = self()

    collection
    |> Enum.map(fn elem ->
      spawn_link(fn -> send(me, {self(), fun.(elem)}) end)
    end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, result} ->
          result
      end
    end)
  end

  def print(collection) do
    current = self()

    collection
    |> Enum.map(fn x -> spawn(fn -> send(current, {self(), x * 2}) end) end)
    |> Enum.map(fn pid ->
      receive do
        {^pid, item} ->
          item
      end
    end)
  end

  def print_speed(collection) do
    {time, result} = :timer.tc(Parallel, :print, [collection])
    IO.puts("#{time}μs -> #{inspect(result)}")
  end
end
