Para correr el .sh en Linux primero hay que darle permisos de ejecución:

- chmod +x admin_tool.sh

Luego para ejecutarlo:

- ./admin_tool.sh


## Adapté el proyecto de bash para que se pudiera ejecutar en mi máquina macOS, ya que no hay muchas diferencias,
las principales fueron:

### Sección de procesos
En macOS, el comando `ps` no soporta la opción `--sort`, por lo que `ps aux --sort=-%cpu` y `ps aux --sort=-$mem`
no funcionarán.

La solución fue: Utilizar el comando `ps` junto con `sort` y `head` para lograr el mismo resultado:

`2) ps aux | sort -nrk 3 | head -n 5;;` : sort -nrk 3: Ordena numéricamente (-n), en orden inverso (-r), basándose en la columna 3 (-k 3), que corresponde al uso de CPU.
`3) ps aux | sort -nrk 4 | head -n 5;;` : sort -nrk 4: Similar al anterior, pero basado en la columna 4, que corresponde al uso de memoria.


### Sección de Usuarios
En macOS el comando `chage` no está disponible, por lo que `sudo chage -l $(whoami)` no funciona.

La solución fue usar el comando `sudo dscl . -read /Users/$(whoami) accountPolicyData | grep passwordLastSetTime
    ;;` para obtener información sobre la contraseña.

### Sección de Backup
En macOS los directorios de usuario están en `/Users` no en `/home`

La solución fue cambiar la ruta del directorio a respaldar de `/home` a `/Users`
`tar -czvf "$directorio_backup/$archivo_backup" /Users
`

