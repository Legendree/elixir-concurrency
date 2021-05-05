defmodule Greeter do
  def greet() do
    receive do
      {prev_pid, message} ->
        send(prev_pid, "Hello processor #{message}")
    end
  end
end

defmodule Spawner do
  def start(n) do
    pids = Enum.map(1..n, fn _ -> spawn(Greeter, :greet, []) end)
    pids |> Enum.each(&send(&1, {self(), "Hello"}))
  end
end
