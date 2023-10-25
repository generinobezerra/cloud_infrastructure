terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "~> 2.7"
    }
  }
}

# Define o provedor Docker para Terraform.
provider "docker" {
  host    = "unix:///var/run/docker.sock"  # Endereço do socket Docker (pode variar dependendo do sistema).
}

# Crie uma rede Docker para conectar os contêineres.
resource "docker_network" "my_network" {
  name = "my_network"
}

# Crie um contêiner MariaDB.
resource "docker_container" "mariadb" {
  name  = "mariadb"
  image = "mariadb:5.5"
  env   = ["MYSQL_ROOT_PASSWORD=test", "MYSQL_DATABASE=test", "MYSQL_USER=test", "MYSQL_PASSWORD=test"]
  ports {
    internal = 3306
    external = 3306
  }
  network_mode = docker_network.my_network.name
}

# Crie um contêiner para o aplicativo Node.js (Generino/Cloud-Infrastructure) que depende do MariaDB.
resource "docker_container" "app" {
  name  = "cloud-infrastructure-app"
  image = "generino/cloud-infrastructure"
  ports {
    internal = 3000
    external = 3000
  }
  network_mode = docker_network.my_network.name
  depends_on = [docker_container.mariadb]
  command = ["yarn", "install"]
  restart = "always"  # Reiniciar o contêiner automaticamente em caso de falha.
}

# Execute a migração do TypeORM após o contêiner do aplicativo ser criado.
resource "null_resource" "typeorm_migration" {
  depends_on = [docker_container.app]
  provisioner "local-exec" {
    command = "yarn run typeorm migration:run"
    working_dir = path.module  # O caminho deve apontar para o diretório contendo o código Terraform.
  }
}
