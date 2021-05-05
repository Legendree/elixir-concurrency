defmodule Cat do
  def cat(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:cat, pid, file} ->
        content = File.read!(to_string(file))
        send(pid, {:answer, to_string(content) =~ "cat"})
        cat(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, to_process) do
    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_process, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} when queue != [] ->
        [head | tail] = queue
        send(pid, {:cat, self(), head})
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})
        results

      {:answer, is_cat} ->
        schedule_processes(processes, queue, [is_cat | results])
    end
  end
end

Enum.each(1..10, fn num_processes ->
  {time, result} = :timer.tc(Scheduler, :run, [num_processes, Cat, :cat, File.ls!()])

  if num_processes == 1 do
    IO.puts(inspect(result))
    IO.puts("\n #   time (ps)")
  end

  :io.format("~2B     ~.2f~n", [num_processes, time / 1.0])
end)
