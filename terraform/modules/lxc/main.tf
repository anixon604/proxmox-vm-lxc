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

# Configure apt-cacher-ng in a separate resource
resource "null_resource" "apt_cacher_config" {
  count = var.create_lxc && var.apt_cacher_ng_endpoint != null ? 1 : 0

  triggers = {
    container_id = proxmox_lxc.container[0].id
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.lxc_ssh_private_key)
      host        = data.external.get_lxc_ip.result.ip
    }

    inline = [
      "echo 'Acquire::http::Proxy \"${var.apt_cacher_ng_endpoint}\";' > /etc/apt/apt.conf.d/01proxy",
      "echo 'Acquire::https::Proxy \"${var.apt_cacher_ng_endpoint}\";' >> /etc/apt/apt.conf.d/01proxy"
    ]
  }

  depends_on = [data.external.get_lxc_ip]
}
