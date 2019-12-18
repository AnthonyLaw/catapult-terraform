resource "digitalocean_firewall" "catapult-node" {
    name = "ssh-and-catapult-port"
    droplet_ids = ["${digitalocean_droplet.catapult-node.id}"]

    inbound_rule {
        protocol         = "tcp"
        port_range       = "22"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "3000"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }

    inbound_rule {
        protocol         = "tcp"
        port_range       = "7900-7902"
        source_addresses = ["0.0.0.0/0", "::/0"]
    }
}