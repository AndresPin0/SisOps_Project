#!/bin/bash

while true; do
    echo "---------------------------------------------"
    echo "      Herramienta de Administración macOS    "
    echo "---------------------------------------------"
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
                    1)
                        ps aux
                        ;;
                    2)
                        ps aux | sort -nrk 3 | head -n 5
                        ;;
                    3)
                        ps aux | sort -nrk 4 | head -n 5
                        ;;
                    4)
                        read -p "Ingrese el PID del proceso a terminar: " pid
                        if kill $pid 2>/dev/null; then
                            echo "Proceso $pid terminado."
                        else
                            echo "No se pudo terminar el proceso $pid."
                        fi
                        ;;
                    5)
                        break
                        ;;
                    *)
                        echo "Opción inválida. Por favor, intente de nuevo."
                        ;;
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
                    1)
                        cut -d: -f1 /etc/passwd
                        ;;
                    2)
    echo "Listado de usuarios y detalles de la cuenta:"
    for user in $(dscl . list /Users | grep -v '_'); do
        account_info=$(sudo dscl . -read /Users/$user)
        
        creation_date=$(echo "$account_info" | grep "creationTimestamp:" | cut -d' ' -f2-)
        if [[ ! -z "$creation_date" ]]; then
            echo "Usuario: $user - Fecha de creación de la cuenta: $creation_date"
        else
            echo "Usuario: $user - Detalles de la cuenta no disponibles"
        fi
    done
    ;;
                    3)
                        read -p "Ingrese el nombre de usuario: " usuario
                        sudo passwd $usuario
                        ;;
                    4)
                        break
                        ;;
                    *)
                        echo "Opción inválida. Por favor, intente de nuevo."
                        ;;
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
            tar -czvf "$directorio_backup/$archivo_backup" /Users
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
        5)
            exit 0
            ;;
        *)
            echo "Opción inválida. Por favor, intente de nuevo."
            ;;
    esac
done
