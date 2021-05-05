defmodule Notes do
  def factorial(0), do: 1
  def factorial(n), do: n * factorial(n - 1)

  def tail_rec_factorial(n), do: _fact(n, 1)

  defp _fact(1, acc), do: acc

  defp _fact(n, acc) do
    _fact(n - 1, n * acc)
  end
end
