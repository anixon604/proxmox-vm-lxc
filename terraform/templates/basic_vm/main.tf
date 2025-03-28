terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url != null ? var.pm_api_url : env("PM_API_URL")
  pm_tls_insecure     = true
  pm_debug            = true
}

module "vm" {
  source         = "../modules/qemu" # or "../modules/lxc"
  name           = var.name
  target_node    = var.target_node
  clone          = var.clone
  cores          = var.cores
  sockets        = var.sockets
  memory         = var.memory
  disk_size      = var.disk_size
  storage        = var.storage
  bridge         = var.bridge
  ciuser         = var.ciuser
  cipassword     = var.cipassword
  sshkeys        = var.sshkeys
  use_dhcp       = var.use_dhcp
  ip_address     = var.ip_address
  netmask        = var.netmask
  gateway        = var.gateway
  pve_user       = var.pve_user
  pve_host       = var.pve_host
  pve_private_key = var.pve_private_key
  packages       = var.packages
  tags           = var.tags
}
