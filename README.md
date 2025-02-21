
### Project Zomboid Dedicated Server - Terraform Deployment

Este projeto provisiona e gerencia um servidor dedicado de Project Zomboid usando Terraform e Docker.

## 🚀 Pré-requisitos

- Terraform instalado
- Docker instalado
- Credenciais configuradas (ex.: GCP ou AWS, dependendo do seu provedor de nuvem)

## ⚙️ Configuração do Terraform

1. **Inicialize o Terraform:**
   ```bash
   terraform init
   ```

2. **Valide a configuração:**
   ```bash
   terraform validate
   ```

3. **Aplique a infraestrutura:**
   ```bash
   terraform apply
   ```
   Confirme a aplicação digitando `yes` quando solicitado.

## 🔄 Gerenciamento do Servidor

O script `pz_server_manager.sh` permite gerenciar facilmente o servidor de Project Zomboid.

- ** Navegue até o user pz_admin com o comando: **
 ```bash
  sudo -u pz_admin -s
  ```

### Comandos disponíveis:

- **Iniciar o servidor:**
  ```bash
  ./pz_server_manager.sh start
  ```
  Inicia o servidor Zomboid, criando um novo container Docker caso necessário.

- **Parar o servidor:**
  ```bash
  ./pz_server_manager.sh stop
  ```
  Encerra o servidor de forma segura e para o container Docker.

- **Instalar mods:**
  ```bash
  ./pz_server_manager.sh install-mod <workshop_item_id> <mod_id>
  ```
  Instala o mod especificado pelo ID da Steam Workshop.

- **Visualizar logs:**
  ```bash
  ./pz_server_manager.sh logs
  ```
  Exibe os logs atuais do servidor para ajudar na resolução de problemas.

- **Editar configurações do servidor:**
  ```bash
  ./pz_server_manager.sh edit
  ```
  Abre o arquivo de configuração do servidor para ajustes manuais.

- **Limpar containers Docker antigos:**
  ```bash
  ./docker-clear.sh
  ```
  Remove containers parados e libera espaço.

## 🛠️ Destruir a Infraestrutura

Para remover todos os recursos criados:

```bash
terraform destroy
```

Digite `yes` para confirmar.

## 📄 Licença

Este projeto está licenciado sob a MIT License.
