#!/bin/bash
LOGFILE="script.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOGFILE"
}

print_header() {
    log "Generando informe del sistema..."
    echo "=============================="
    echo "Informe del sistema: $(hostname -s)"
    echo "=============================="
}

get_root_space() {
    local point=$1
    if df -h "$point" &>/dev/null; then
        log "Espacio en disco en $point obtenido correctamente."
        echo "Uso del Disco $(df -h "$point" | awk 'NR > 1 {print $7}')"
    else
        log "Error al obtener espacio en disco en $point."
        exit 1
    fi
}

buscar_proceso() {
    while true; do
        read -p "Ingrese el proceso que desea buscar: " proceso
        if [[ -z "$proceso" ]]; then
            log "Entrada vacía. Se requiere un nombre de proceso."
            echo "Debe ingresar un nombre de proceso."
        else
            log "Buscando procesos con el nombre: $proceso"
            procesos_encontrados=$(ps aux | grep -i --color=auto "$proceso" | grep -v grep || true)

            if [[ -z "$procesos_encontrados" ]]; then
                log "No se encontraron procesos con el nombre '$proceso'."
                echo "No se encontraron procesos con el nombre '$proceso'. Vuelve a intentar"
            else
                log "Se encontró el proceso '$proceso'."
                echo "Se encontró el proceso, estos son los resultados:"
                echo "$procesos_encontrados"
                break
            fi
        fi
    done
}

main(){
    print_header
    get_root_space "/"
    buscar_proceso
    log "Finalizando script..."
    echo "Fin del informe"
}

# Ejecutar el script
main
