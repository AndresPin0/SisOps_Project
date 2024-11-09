#!/bin/bash

while true; do
    echo "---------------------------------------"
    echo "      Herramienta de Administración     "
    echo "---------------------------------------"
    echo "Seleccione una opción:"
    echo "1. Procesos"
    echo "2. Usuarios"
    echo "3. Backup"
    echo "4. Apagar el equipo"
    echo "5. Salir"
    read -p "Opción: " opcion_principal

    case $opcion_principal in
        1)
          while true; do
                  echo "----------- Menú de Procesos -----------"
                  echo "1. Listar procesos"
                  echo "2. Top 5 procesos por uso de CPU"
                  echo "3. Top 5 procesos por uso de Memoria"
                  echo "4. Terminar un proceso"
                  echo "5. Volver al menú principal"
                  read -p "Opción: " opcion_procesos

                  case $opcion_procesos in
                      1) ps aux;;
                      2) ps aux --sort=-%cpu | head -n 6;;
                      3) ps aux --sort=-%mem | head -n 6;;
                      4)
                          read -p "Ingrese el PID del proceso a terminar: " pid
                          kill $pid && echo "Proceso $pid terminado." || echo "No se pudo terminar el proceso."
                          ;;
                      5) break;;
                      *) echo "Opción inválida. Por favor, intente de nuevo.";;
                  esac
              done
              ;;
        2)
          while true; do
                  echo "----------- Menú de Usuarios -----------"
                  echo "1. Listar usuarios del sistema"
                  echo "2. Listar usuarios según la vejez de su contraseña"
                  echo "3. Cambiar la contraseña de un usuario"
                  echo "4. Volver al menú principal"
                  read -p "Opción: " opcion_usuarios

                  case $opcion_usuarios in
                      1) cut -d: -f1 /etc/passwd;;
                      2)
                          sudo chage -l $(whoami)
                          ;;
                      3)
                          read -p "Ingrese el nombre de usuario: " usuario
                          sudo passwd $usuario
                          ;;
                      4) break;;
                      *) echo "Opción inválida. Por favor, intente de nuevo.";;
                  esac
              done
              ;;
        3)
          read -p "Ingrese la ruta del directorio de backup: " directorio_backup
              if [ ! -d "$directorio_backup" ]; then
                  echo "El directorio no existe. Creándolo..."
                  mkdir -p "$directorio_backup"
              fi
              fecha=$(date +%Y%m%d)
              archivo_backup="backup_usuarios_$fecha.tar.gz"
              tar -czvf "$directorio_backup/$archivo_backup" /home
              echo "Backup realizado en $directorio_backup/$archivo_backup"
              ;;
        4)
          read -p "¿Está seguro de que desea apagar el equipo? (s/n): " confirmacion
              if [ "$confirmacion" == "s" ]; then
                  sudo shutdown -h now
              else
                  echo "Operación cancelada."
              fi
              ;;

        5) exit 0;;
        *) echo "Opción inválida. Por favor, intente de nuevo.";;
    esac
done
