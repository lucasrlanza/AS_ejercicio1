# Implementacion concurrente de primos/1
defmodule Eratostenes do

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
