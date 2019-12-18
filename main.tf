
provider "digitalocean" {
  token = "${var.do_token}"
}

data "digitalocean_ssh_key" "mykey" {
  name = "terraform_catapult_node"
}

resource "digitalocean_droplet" "catapult-node" {
    image = "ubuntu-18-04-x64"
    name = "catapult-node-1"
    region = "sgp1"
    size = "s-1vcpu-2gb"
    ssh_keys = ["${data.digitalocean_ssh_key.mykey.id}"]

    provisioner "remote-exec" {

      inline = [
        "export PATH=$PATH:/usr/bin",
        "curl -fsSL https://get.docker.com -o get-docker.sh",
        "sudo sh get-docker.sh",
        "curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null",
        "sudo chmod +x /usr/local/bin/docker-compose",
        "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
        "git config --global --unset http.proxy",
        "git config --global --unset https.proxy",
        "git clone https://github.com/nemfoundation/catapult-testnet-bootstrap.git",
        "cd catapult-testnet-bootstrap/api-harvest-assembly",
        "sudo docker-compose up --build --detach"
      ]

      connection {
        type     = "ssh"
        private_key = "${file(var.private_key)}"
        user     = "root"
        timeout  = "2m"
        host = "${self.ipv4_address}"
      }
  }
}