defmodule Booper do
  # name for the global pid
  @name :booper
  # interval in ms
  @interval 1250

  def start do
    pid = spawn(__MODULE__, :booper, [[]])
    :global.register_name(@name, pid)
  end

  def register(%{:pid => _pid, :name => _client_name} = client_data) do
    send(:global.whereis_name(@name), {:register, client_data})
  end

  def booper(clients) do
    receive do
      {:register, client_data} ->
        IO.puts("Client registered #{inspect(client_data.name)}")
        booper([client_data | clients])
    after
      @interval ->
        IO.puts("boop")
        Enum.each(clients, fn %{:pid => client, :name => name} -> send(client, {:boop, name}) end)
        booper(clients)
    end
  end
end

defmodule Client do
  def start(client_name) do
    pid = spawn(__MODULE__, :reciever, [])
    Booper.register(%{:pid => pid, :name => client_name})
  end

  def reciever do
    receive do
      {:boop, name} ->
        IO.puts("bloop from the client #{inspect(name)}")
        reciever()
    end
  end
end
