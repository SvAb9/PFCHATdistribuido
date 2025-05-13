defmodule ClienteChat do
  def iniciar do
    IO.puts("Escribe tu nombre de usuario:")
    usuario = IO.gets("> ") |> String.trim()
    IO.puts("Bienvenido #{usuario}! Escribe un comando.")
    bucle(usuario, nil)
  end

  defp bucle(usuario, sala_actual) do
    entrada = IO.gets("> ") |> String.trim()

    case String.split(entrada) do
      ["/create", sala] ->
        case GenServer.call({:global, :servidor_chat}, {:crear_sala, sala}) do
          :ok -> IO.puts("Sala '#{sala}' creada."); bucle(usuario, sala)
          {:error, :ya_existe} -> IO.puts("La sala ya existe."); bucle(usuario, sala_actual)
        end

      ["/join", sala] ->
        IO.puts("Te uniste a la sala '#{sala}'")
        bucle(usuario, sala)

      ["/history"] ->
        if sala_actual do
          contenido = GenServer.call({:global, :servidor_chat}, {:historial, sala_actual})
          IO.puts(contenido)
        else
          IO.puts("No estás en ninguna sala.")
        end
        bucle(usuario, sala_actual)

      ["/exit"] ->
        IO.puts("Adiós!")

      _ ->
        if sala_actual do
          GenServer.call({:global, :servidor_chat}, {:enviar_mensaje, sala_actual, usuario, entrada})
        else
          IO.puts("Únete primero a una sala con /join nombre_sala")
        end
        bucle(usuario, sala_actual)
    end
  end
end


#pasos para local

#servidor
#iex.bat --sname servidor --cookie chat
#c("servidor_chat.ex")
# ServidorChat.main()

#cliente
#iex.bat --sname cliente --cookie chat
#Node.connect(:"servidor@Sonic")
#c("cliente_chat.ex")
#ClienteChat.iniciar()

#pasos para local

#servidor
#iex.bat --sname servidor --cookie chat
#c("servidor_chat.ex")
# ServidorChat.main()

#cliente
#iex.bat --sname cliente --cookie chat
#Node.connect(:"servidor@Sonic")
#c("cliente_chat.ex")
#ClienteChat.iniciar()
