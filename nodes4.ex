defmodule Server do
  @name :server

  def starter(first_client) do
    receive do
      {:start} ->
        IO.puts("Starting client ring")
        send(first_client, {:tick})
    end
  end

  def start_ring(n) when is_number(n) do
    first = Client.start_clients(n)

    IO.puts(inspect(first))

    server_pid = spawn(__MODULE__, :starter, [first])
    :global.register_name(@name, server_pid)

    send(:global.whereis_name(@name), {:start})
  end
end

defmodule Client do
  @interval 2000

  def start_clients(n) do
    1..n
    |> Enum.reduce(self(), fn processor_index, next_pid ->
      spawn(Client, :receiver, [next_pid, processor_index])
    end)
  end

  def receiver(next_client, processor_index) do
    receive do
      {:tick} ->
        IO.puts("Tick received on processor #{processor_index}!")
        send(next_client, {:tick})
    end
  end
end
