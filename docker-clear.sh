#!/bin/bash

# Parar todos os containers em execução
sudo docker stop $(sudo docker ps -q)

# Remover todos os containers
sudo docker rm $(sudo docker ps -a -q)

# Remover todas as imagens não utilizadas
sudo docker rmi $(sudo docker images -q)

# Remover redes não utilizadas
sudo docker network prune -f

# Remover volumes não utilizados
sudo docker volume prune -f

# Remover containers, imagens, redes e volumes não utilizados (opcional)
sudo docker system prune -af
