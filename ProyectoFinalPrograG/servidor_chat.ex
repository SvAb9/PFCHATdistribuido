defmodule ServidorChat do
  use GenServer

  ## Inicio

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: {:global, :servidor_chat})
  end

  def main do
    start_link(nil)
    Process.sleep(:infinity)
  end

  ## Callbacks

  def init(_) do
    File.mkdir_p!("historial")
    {:ok, %{salas: %{}}}
  end

  def handle_call({:crear_sala, nombre}, _from, state) do
    if Map.has_key?(state.salas, nombre) do
      {:reply, {:error, :ya_existe}, state}
    else
      nuevo_state = put_in(state.salas[nombre], [])
      {:reply, :ok, nuevo_state}
    end
  end

  def handle_call({:enviar_mensaje, sala, usuario, mensaje}, _from, state) do
    case Map.fetch(state.salas, sala) do
      :error -> {:reply, {:error, :sala_no_encontrada}, state}
      {:ok, mensajes} ->
        nuevo_mensajes = mensajes ++ [{usuario, mensaje}]
        nuevo_state = put_in(state.salas[sala], nuevo_mensajes)
        guardar_historial(sala, usuario, mensaje)
        {:reply, :ok, nuevo_state}
    end
  end

  def handle_call({:historial, sala}, _from, state) do
    case File.read("historial/#{sala}.txt") do
      {:ok, contenido} -> {:reply, contenido, state}
      {:error, _} -> {:reply, "No hay historial aún.", state}
    end
  end

  ## Privado
  defp guardar_historial(sala, usuario, mensaje) do
    File.write!("historial/#{sala}.txt", "[#{usuario}]: #{mensaje}\n", [:append])
  end
end
