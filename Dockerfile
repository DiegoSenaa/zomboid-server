FROM steamcmd/steamcmd:ubuntu-jammy

# Definir variável do diretório do servidor
ENV PZ_SERVER_DIR="/opt/pzserver"

RUN apt-get update && apt-get install nano

# Criar diretório e instalar servidor do Zomboid
RUN mkdir -p $PZ_SERVER_DIR && \
    steamcmd +force_install_dir $PZ_SERVER_DIR +login anonymous +app_update 380870 validate +quit

# Expor portas necessárias
EXPOSE 16261/udp
EXPOSE 16262/udp

# Definir diretório de trabalho
WORKDIR $PZ_SERVER_DIR

# Garantir que o script de inicialização tenha permissão de execução
RUN chmod +x start-server.sh

# Comando de inicialização do servidor
ENTRYPOINT ["./start-server.sh", "-adminpassword", "SenhaSegura123"]