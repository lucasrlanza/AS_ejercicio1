defmodule Erastotenes do

  @spec primos(integer()) :: list(integer())
  def primos(n) do
    lista = Enum.to_list(2..n)
    cribar(lista)
  end


  defp cribar([]) do
    []
  end

  defp cribar([p | resto]) do
    filtrado = filtrar(resto, p)
    [p | cribar(filtrado)]
  end

  defp filtrar([], _divisor) do
    []
  end

  defp filtrar([h | t], divisor) when rem(h, divisor) == 0 do
    filtrar(t, divisor)
  end

  defp filtrar([h | t], divisor) do
    [h | filtrar(t, divisor)]
  end

end


#Test rapidos para comprobar que funciona (no se muy bien como prorbarlos pero puedes hacer elixir eratostenes.exs y va )
