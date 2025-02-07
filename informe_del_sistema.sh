# Documentacion oficinal del comando set: 
# https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -euo pipefail

print_header() {
    # imprimo un encabezado con el nombre de host.
    echo "=============================="
    echo "Informe del sistema: $(hostname -s)"
    echo "=============================="
}

# Imprimir la fecha con el formato DD/MM/YYYY HH:MM:SS

echo "Fecha y Hora: $(date '+%d/%m/%Y %H:%M:%S')"
echo ""
get_root_space() {
    local point=$1
    # imprimo el espacio disponible de la unidad root (/)
    echo "Uso del Disco $(df -h $point | awk 'NR > 1 {print $7}')"
}

# usuario logueados

echo "Estos son los usuario que estan usando el sistema"

who | awk '{print $1}'

# el comando free -m nos muestra la memoria (no esta disponible en mi mac)

while true; do
    read -p "Ingrese el proceso que desea buscar: " proceso
    if [[ -z "$proceso" ]]; then
        echo "Debe ingresar un nombre de proceso"
    else
        echo "Los datos del procesos son: "
        procesos_encontrados=$(ps aux | grep -i --color=auto "$proceso" | grep -v grep|| true)

        if [[ -z "$procesos_encontrados" ]]; then # la evaluacion no esta siendo tomada.
            echo "No se encontraron procesos con el nombre '$proceso'. Vuelve a intentar"
        else
            echo "Se encontro el proceso estos son los resultados"
            echo "$procesos_encontrados"
            break
        fi
        echo $procesos_encontrados
    fi
done

main(){
    print_header
    get_root_space "/"
    echo "Fin del informe"
}
main