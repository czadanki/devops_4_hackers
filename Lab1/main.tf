resource "digitalocean_tag" "project_tag" {
  name = "devops"
}

resource "digitalocean_ssh_key" "ssh_key" {
  name       = "Dev SSH Key"
  public_key = file("/home/czaki/.ssh/id_rsa.pub")
}

resource "digitalocean_droplet" "devops-vm-1" {
  image = "ubuntu-20-04-x64"
  name = "devops-vm-1"
  region = "fra1"
  size = "s-1vcpu-1gb"
  tags = [digitalocean_tag.project_tag.id]
  private_networking = true
  ssh_keys = [
    digitalocean_ssh_key.ssh_key.fingerprint
  ]
}

resource "digitalocean_firewall" "firewall" {
  name = "devops-vm-1"

  droplet_ids = [digitalocean_droplet.devops-vm-1.id]
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["143.198.104.91/32"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["143.198.104.91/32"]
  }

    inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["143.198.104.91/32"]
  }

    inbound_rule {
    protocol         = "tcp"
    port_range       = "7443"
    source_addresses = ["143.198.104.91/32"]
  }
  outbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
  outbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    destination_addresses = ["0.0.0.0/0"]
  }
} 