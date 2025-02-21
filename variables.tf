variable "region" {
    type = string
    default = "southamerica-east1"
}

variable "zone" {
    type = string
    default = "southamerica-east1-a"
}

variable "project" {
    type = string
    default = "sonorous-pact-451318-e2"
}
variable "valheim-key-name" {
    type = string
    default = "valheim-server-key"
}
variable "user" {
  type = string
  default = "root"
}

variable "image" {
  type = string
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "dockerfile" {
  default = "Dockerfile"
}

variable "server_manager_script" {
  default = "pz_server_manager.sh"
}

variable "server_run" {
  default = "server-run.sh"
}