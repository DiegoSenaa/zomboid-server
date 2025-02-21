#!/bin/bash

CONTAINER_NAME="zomboid-server"
PZ_SERVER_DIR="/root/Zomboid"
SERVER_CONFIG="$PZ_SERVER_DIR/Server/servertest.ini"
MODS_FILE="$PZ_SERVER_DIR/mods.txt"
LOG_FILE="$PZ_SERVER_DIR/server-console.txt"
SERVER_CMD="./start-server.sh"
PID_FILE="$PZ_SERVER_DIR/server.pid"

# Exibe ajuda
show_help() {
    echo "Uso: $0 [opção]"
    echo "Opções disponíveis:"
    echo "  start                              - Inicia o servidor"
    echo "  stop                               - Para o servidor"
    echo "  restart                            - Reinicia o servidor"
    echo "  logs                               - Exibe os logs do servidor"
    echo "  addmod <workshop_item_id> <mod_id> - Adiciona um mod ao servidor"
    echo "  edit                               - Editar arquivo de configs do server" 
    exit 0
}

# Inicia o servidor
start_server() {
    echo "🚀 Iniciando o servidor do Project Zomboid..."
    sudo docker start -d $CONTAINER_NAME
    echo "✅ Servidor iniciado!"
}

# Para o servidor
stop_server() {
    echo "🛑 Parando o servidor..."
    sudo docker stop $CONTAINER_NAME
    echo "✅ Servidor parado!"
}

# Reinicia o servidor
restart_server() {
    echo "🔄 Reiniciando o servidor..."
    sudo docker restart $CONTAINER_NAME
}

# Exibe logs em tempo real
show_logs() {
    echo "📜 Exibindo logs do servidor..."
    sudo docker exec -it $CONTAINER_NAME sh -c "tail -f $PZ_SERVER_DIR/Logs/*.txt"
}

# Adiciona mods ao servidor
add_mod() {
    WORKSHOP="$1"
    MOD="$2"

    # Verifica se ambos os parâmetros foram passados
    if [ -z "$WORKSHOP" ] || [ -z "$MOD" ]; then
        echo "❌ Erro: Você precisa fornecer o workshop_id e o mod_id."
        echo "Uso: $0 <workshop_id > <mod_id>"
        exit 1
    fi

    NEW_MOD="${WORKSHOP}:${MOD}"

    # Executa o comando dentro do Docker
    sudo docker exec -it "$CONTAINER_NAME" sh -c "sed -i '/^Mods=/ s/$/$MOD;/' '$SERVER_CONFIG' && sed -i '/^WorkshopItems=/ s/$/$WORKSHOP;/' '$SERVER_CONFIG'"

    echo "✅ Mod '$NEW_MOD' adicionado ao servidor Zomboid!"
    echo "❌ Reinicio do servidor é obrigatorio"
}
# Editar cfg server
edit() {
    echo "📜 Abrindo servertest.ini ..."
    sudo docker exec -it zomboid-server sh -c "nano /root/Zomboid/Server/servertest.ini"
}

# Verifica os argumentos passados
case "$1" in
    start) start_server ;;
    stop) stop_server ;;
    restart) restart_server ;;
    logs) show_logs ;;
    addmod) add_mod "$2" "$3" ;;
    edit) edit() ;;
    *) show_help ;;
esac
