# Función para mostrar el menú principal
function Show-Menu {
    Write-Host "==== Menú Principal ===="
    Write-Host "1. Gestion de Procesos"
    Write-Host "2. Gestion de Usuarios"
    Write-Host "3. Copia de Seguridad"
    Write-Host "4. Apagar el Equipo"
    Write-Host "0. Salir"
    Write-Host "========================="
}

# Función para listar procesos
function List-Processes {
    Get-Process | Select-Object -Property Id, Name, CPU, WorkingSet64 | Format-Table
}

# Función para mostrar los 5 procesos con mayor uso de CPU
function Top-CPU-Processes {
    Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 5 -Property Id, Name, CPU | Format-Table
}

# Función para mostrar los 5 procesos con mayor uso de memoria
function Top-Memory-Processes {
    Get-Process | Sort-Object -Property WorkingSet64 -Descending | Select-Object -First 5 -Property Id, Name, WorkingSet64 | Format-Table
}

# Función para terminar un proceso
function Kill-Process {
    $processId = Read-Host "Ingrese el ID del proceso a terminar"
    Stop-Process -Id $processId -Force
    Write-Host "Proceso con ID $processId terminado."
}

# Función para listar usuarios del sistema
function List-Users {
    Get-LocalUser | Select-Object -Property Name, Enabled, LastLogon | Format-Table
}

# Función para listar usuarios según antigüedad de contraseñas
function Users-By-PasswordAge {
    Get-LocalUser | Select-Object -Property Name, PasswordLastSet | Sort-Object -Property PasswordLastSet -Descending | Format-Table
}

# Función para cambiar la contraseña de un usuario
function Change-Password {
    $userName = Read-Host "Ingrese el nombre del usuario"
    $newPassword = Read-Host "Ingrese la nueva contrasena" -AsSecureString
    Set-LocalUser -Name $userName -Password $newPassword
    Write-Host "Contrasena del usuario $userName cambiada con exito."
}

# Función para realizar backup del directorio de usuarios
function Backup-Users-Directory {
    try {
        # Pedir al usuario la ruta donde se almacenará el backup
        $backupPath = Read-Host "Ingrese la ruta del directorio de destino para el backup"
        
        # Validar si la ruta ingresada existe
        if (-not (Test-Path $backupPath)) {
            Write-Host "La ruta proporcionada no existe. Por favor, verifique e intente nuevamente." -ForegroundColor Red
            return
        }

        # Generar el nombre del archivo con la fecha y hora actuales
        $timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
        $backupFile = Join-Path $backupPath "UserBackup_$timestamp.zip"

        # Informar al usuario que se inicia el backup
        Write-Host "Iniciando el proceso de backup..." -ForegroundColor Yellow

        # Realizar el backup y mostrar el progreso
        Compress-Archive -Path "C:\Users" -DestinationPath $backupFile -Force -Verbose

        # Confirmar al usuario que el backup se completó
        Write-Host "Backup completado exitosamente. Archivo creado en: $backupFile" -ForegroundColor Green
    } catch {
        # Manejar errores durante el backup
        Write-Host "Ocurrio un error durante el backup: $_" -ForegroundColor Red
    }
}


# Función para apagar el equipo
function Shutdown-System {
    Write-Host "El equipo se apagara en 30 segundos. Presione Ctrl+C para cancelar."
    Shutdown.exe /s /t 30
}

# Función principal para gestionar el menú
function Main {
    do {
        Show-Menu
        $choice = Read-Host "Seleccione una opcion"

        switch ($choice) {
            "1" {
                Write-Host "==== Gestión de Procesos ===="
                Write-Host "a. Listar Procesos"
                Write-Host "b. Top 5 Procesos por CPU"
                Write-Host "c. Top 5 Procesos por Memoria"
                Write-Host "d. Terminar un Proceso"
                Write-Host "e. Volver al Menu Principal"
                $subChoice = Read-Host "Seleccione una opcion"

                switch ($subChoice) {
                    "a" { List-Processes }
                    "b" { Top-CPU-Processes }
                    "c" { Top-Memory-Processes }
                    "d" { Kill-Process }
                    "e" { Write-Host "Volviendo al menu principal..." }
                    default { Write-Host "Opcion no válida." }
                }
            }
            "2" {
                Write-Host "==== Gestion de Usuarios ===="
                Write-Host "a. Listar Usuarios"
                Write-Host "b. Usuarios por Antigüedad de Contrasena"
                Write-Host "c. Cambiar Contrasena de un Usuario"
                Write-Host "d. Volver al Menu Principal"
                $subChoice = Read-Host "Seleccione una opcion"

                switch ($subChoice) {
                    "a" { List-Users }
                    "b" { Users-By-PasswordAge }
                    "c" { Change-Password }
                    "d" { Write-Host "Volviendo al menu principal..." }
                    default { Write-Host "Opcion no válida." }
                }
            }
            "3" { Backup-Users-Directory }
            "4" { Shutdown-System }
            "0" { Write-Host "Saliendo del programa." }
            default { Write-Host "Opcion no valida." }
        }
    } while ($choice -ne "0")
}

# Ejecutar la función principal
Main
