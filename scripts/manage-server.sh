#!/bin/bash

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para mostrar el estado del servidor
check_status() {
    if screen -list | grep -q "minecraft"; then
        echo -e "${GREEN}✅ El servidor está ACTIVO${NC}"
        return 0
    else
        echo -e "${RED}❌ El servidor está INACTIVO${NC}"
        return 1
    fi
}

# Función para mostrar el menú
show_menu() {
    echo -e "\n${YELLOW}=== Gestor del Servidor Minecraft Bedrock ===${NC}"
    echo "1. Iniciar servidor"
    echo "2. Detener servidor"
    echo "3. Ver estado"
    echo "4. Ver logs"
    echo "5. Acceder a la consola"
    echo "6. Salir"
    echo -e "${YELLOW}============================================${NC}"
}

# Función para ver los últimos logs
view_logs() {
    if [ -f "/workspace/minecraft-server/log.txt" ]; then
        echo -e "${YELLOW}Últimas 20 líneas del log:${NC}"
        tail -n 20 /workspace/minecraft-server/log.txt
    else
        echo -e "${RED}No se encontró el archivo de logs${NC}"
    fi
}

# Bucle principal
while true; do
    show_menu
    read -p "Selecciona una opción (1-6): " choice

    case $choice in
        1)
            if ! check_status; then
                echo -e "${YELLOW}🚀 Iniciando el servidor...${NC}"
                ./start-server.sh
            else
                echo -e "${RED}⚠️ El servidor ya está en ejecución${NC}"
            fi
            ;;
        2)
            if check_status; then
                echo -e "${YELLOW}🛑 Deteniendo el servidor...${NC}"
                screen -X -S minecraft quit
                echo -e "${GREEN}✅ Servidor detenido${NC}"
            else
                echo -e "${RED}⚠️ El servidor no está en ejecución${NC}"
            fi
            ;;
        3)
            check_status
            ;;
        4)
            view_logs
            ;;
        5)
            if check_status; then
                echo -e "${YELLOW}📝 Accediendo a la consola...${NC}"
                echo -e "${YELLOW}Para salir: Presiona Ctrl+A seguido de D${NC}"
                sleep 2
                screen -r minecraft
            else
                echo -e "${RED}⚠️ El servidor no está en ejecución${NC}"
            fi
            ;;
        6)
            echo -e "${GREEN}👋 ¡Hasta luego!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Opción inválida${NC}"
            ;;
    esac

    echo -e "\nPresiona Enter para continuar..."
    read
done
