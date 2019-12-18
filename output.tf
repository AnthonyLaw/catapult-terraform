output "fip_output" {
    description = "Droplet ipv4 address"
    value = "${digitalocean_droplet.catapult-node.*.ipv4_address}"
}