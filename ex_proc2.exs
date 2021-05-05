defmodule ExProc2 do
  def receiver(sender_name) do
    receive do
      {:pid, pid} ->
        send(pid, {:ok, sender_name})
        receiver(sender_name)
    end
  end

  def sender() do
    receive do
      {:ok, message} ->
        IO.puts(message)
        sender()
    after
      500 ->
        "No message receieved"
    end
  end
end

pid_fred = spawn(ExProc2, :receiver, ["fred"])
pid_betty = spawn(ExProc2, :receiver, ["betty"])

send(pid_fred, {:pid, self()})
send(pid_betty, {:pid, self()})

ExProc2.sender()
