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