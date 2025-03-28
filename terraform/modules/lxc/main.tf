terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4" # avoid lxc start issue
    }
  }
}

resource "proxmox_lxc" "container" {
  count = var.create_lxc ? 1 : 0

  features {
    nesting = true
  }

  hostname = var.hostname
  cores    = var.cores
  memory   = var.memory
  swap     = var.swap

  network {
    name   = "eth0"
    bridge = var.bridge
    ip     = var.use_dhcp ? "dhcp" : "${var.ip_address}/${var.netmask},gw=${var.gateway}"
  }

  ostemplate    = var.ostemplate
  password      = var.root_password
  target_node   = var.target_node
  unprivileged  = true
  start         = true

  rootfs {
    storage = var.storage
    size    = var.rootfs_size
  }

  ssh_public_keys = var.lxc_ssh_public_keys

  # Add tags or custom identifiers
  tags = join(",", compact(concat(["managed-by-terraform"], var.tags != null ? var.tags : [])))

}
data "external" "get_lxc_ip" {
  program = ["bash", "${path.module}/get_lxc_ip.sh"]

  query = {
    ctid = regex(".*?/lxc/(\\d+)", proxmox_lxc.container[0].id)[0]
    pve_user = var.pve_user
    pve_private_key = var.pve_private_key
    pve_host = var.pve_host
  }

  depends_on = [proxmox_lxc.container]
}
