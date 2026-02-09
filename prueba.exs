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

# Pruebas
IO.puts("=== Criba de Eratóstenes ===\n")

IO.inspect(Erastotenes.primos(10), label: "Primos hasta 10")
IO.inspect(Erastotenes.primos(30), label: "Primos hasta 30")
IO.inspect(Erastotenes.primos(100), label: "Primos hasta 100")

IO.puts("\n=== Tests ===")
assert Erastotenes.primos(2) == [2]
IO.puts("✓ primos(2) = [2]")

assert Erastotenes.primos(10) == [2, 3, 5, 7]
IO.puts("✓ primos(10) = [2, 3, 5, 7]")

assert Erastotenes.primos(20) == [2, 3, 5, 7, 11, 13, 17, 19]
IO.puts("✓ primos(20) = [2, 3, 5, 7, 11, 13, 17, 19]")
