defmodule UtilChat do
    def mostrar_mensaje(mensaje) do
      IO.puts(mensaje)
    end

    def guardar_mensaje(sala, mensaje) do
      # Asegura que la carpeta de historial existe
      File.mkdir_p!("historial")

      # Crea el archivo si no existe, o agrega si ya existe
      File.write!("historial/#{sala}.txt", mensaje <> "\n", [:append])
    end
  end
