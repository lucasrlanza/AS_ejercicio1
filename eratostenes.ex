# Implementacion secuencial de primos/1
defmodule EratostenesSecuencial do

  @spec primos(integer()) :: list(integer())
  def primos(n) when n < 2, do: [] # Si n es menor de 2, no hay números primos
  def primos(n) when n >= 2, do: rango(2, n) |> cribar() # Si n es 2 o mayor, creamos el rango de numeros y se criban

  defp rango(n, m) when n > m, do: [] # Si n > m, no hay rango (lista vacia)
  defp rango(n, m) when n == m, do: [n] # Si n y m son el mismo, el rango es ese numero solo
  defp rango(n, m) when n < m, do: [n | rango(n + 1, m)] # Si n < m, la cabeza del rango es n y la cola el rango de n+1 a m

  defp cribar([]), do: [] # En la criba vacia no hay primos
  defp cribar([p]), do: [p] # Si la criba tiene solo 1 elemento, es primo
  # Si tiene mas de 1 elemento, el primero es primo, el resto se filtran en base al 1º y se criban de forma recursiva
  defp cribar([p | resto]), do: [p | cribar(filtrar(p, resto))]

  defp filtrar(_p, []), do: [] # Si la lista a filtrar esta vacia, no hay nada que filtrar
  defp filtrar(p, [x | xs]) when rem(x, p) == 0, do: filtrar(p, xs) # Si x es múltiplo de p -> descartamos x y filtramos el resto
  defp filtrar(p, [x | xs]), do: [x | filtrar(p, xs)] # Si x no es múltiplo de p -> x es primo, seguimos filtrando el resto

end
