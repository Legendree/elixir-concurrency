import :timer, only: [sleep: 1]

defmodule Messanger do
  def massagee(parent_pid) do
    # send(parent_pid, {:ok, "some message"})
    exit(:boom)
  end
end

spawn_monitor(Messanger, :massagee, [self()])

sleep(500)

receive do
  {:ok, message} ->
    IO.puts(inspect(message))

  msg ->
    IO.puts("Generic message: #{inspect(msg)}")
after
  1000 ->
    "No messages receieved"
end
