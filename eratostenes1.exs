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

# Implementacion concurrente de primos/1
defmodule EratostenesConcurrente do

  @spec primos(integer()) :: list(integer())
  def primos(n) when n < 2, do: []
  def primos(n) when n >= 2 do
    parent = self()

    case rango(2, n) do
      [] ->
        [] # Si el rango esta vacio, no hay primos

      [primero | cola] ->
        cabeza = spawn(fn -> filtro(primero, nil, parent) end) # Creamos un proceso para el primer primo
        enviar_numeros(cabeza, cola) # Enviamos el resto de los numeros a proceso cabeza
        send(cabeza, {:fin, parent}) # Enviamos el mensaje de fin a cabeza

        receive do
          {:primos, primos} -> primos
        end
    end

  end

  defp rango(n, m) when n > m, do: []
  defp rango(n, m) when n == m, do: [n]
  defp rango(n, m) when n < m, do: [n | rango(n + 1, m)]

  defp enviar_numeros(_pid, []), do: :ok # Si la lista esta vacia, no hay numeros a enviar
  defp enviar_numeros(pid, [x | xs]) do
    send(pid, {:num, x}) # Enviamos el número x al proceso pid
    enviar_numeros(pid, xs) # Continuamos enviando el resto de la lista
  end

  defp filtro(primo, siguiente, parent) do
    receive do
      {:num, x} ->
        cond do
          rem(x, primo) == 0 ->
            filtro(primo, siguiente, parent) # si x es divisible por primo, descartamos y pasamos el siguiente

          siguiente == nil ->
            nuevo = spawn(fn -> filtro(x, nil, parent) end)
            filtro(primo, nuevo, parent) # si no existe un siguiente, creamos un nuevo proceso para el nuevo primo

          true ->
            send(siguiente, {:num, x}) # si x no es divisible por el primo, se envia al siguiente filtro
            filtro(primo, siguiente, parent)
        end

      {:fin, from} ->
        if siguiente == nil do
          send(from, {:primos, [primo]}) # si no hay siguiente, enviamos el primo al proceso solicitante
        else
          send(siguiente, {:fin, self()}) # si hay siguiente, se envia mensaje de fin al siguiente

          receive do
            {:primos, primos} -> send(from, {:primos, [primo | primos]}) # recibimos la lista de primos y la enviamos hacia atrás
          end
        end
    end
  end
end
