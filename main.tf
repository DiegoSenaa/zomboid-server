terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

provider "google" {
  credentials = file("sonorous-pact-451318-e2-ebcceee755a4.json")
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "tls_private_key" "pz_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "pz_private_key" {
  filename        = "${path.module}/pz_server_key"
  content         = tls_private_key.pz_ssh_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "pz_public_key" {
  filename = "${path.module}/pz_server_key.pub"
  content  = tls_private_key.pz_ssh_key.public_key_openssh
}

resource "google_compute_firewall" "pz_firewall" {
  name    = "pz-server-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "16261", "16262"]
  }
  allow {
    protocol = "udp"
    ports    = ["16261", "16262"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags   = ["zomboid"]

  disabled = false

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_address" "pz_server_ip" {
  name         = "pz-server-ip"
  address_type = "EXTERNAL"
}

resource "google_compute_instance" "pz_server" {
  name         = "pz-server"
  machine_type = "e2-standard-2"
  zone         = var.zone
  tags         = ["zomboid", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = var.image
      size  = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.pz_server_ip.address
    }
  }

  metadata = {
    "ssh-keys" = "pz_admin:${tls_private_key.pz_ssh_key.public_key_openssh}"
  }

  provisioner "file" {
    source      = "${path.module}/${var.dockerfile}"
    destination = "/home/pz_admin/Dockerfile"
  }

  provisioner "file" {
    source      = "${path.module}/${var.server_manager_script}"
    destination = "/home/pz_admin/pz_server_manager.sh"
  }

  provisioner "file" {
    source      = "${path.module}/${var.server_run}"
    destination = "/home/pz_admin/server-run.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/pz_admin/pz_server_manager.sh",
      "chmod +x /home/pz_admin/server-run.sh",
      "echo 'Scripts copiados com sucesso!' >> /tmp/provisioning.log",
      "bash /home/pz_admin/server-run.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "pz_admin"
    private_key = tls_private_key.pz_ssh_key.private_key_pem
    host        = google_compute_address.pz_server_ip.address
  }
}
