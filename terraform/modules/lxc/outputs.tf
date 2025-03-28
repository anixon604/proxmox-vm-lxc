output "vmid" {
  description = "The Proxmox VM ID of the LXC container"
  value       = proxmox_lxc.container[0].vmid
}

output "hostname" {
  description = "The hostname of the container"
  value       = proxmox_lxc.container[0].hostname
}

output "ip_address" {
  description = "The IP address of the container"
  value = data.external.get_lxc_ip.result.ip
}

output "lxc_ssh_public_keys" {
  value = var.lxc_ssh_public_keys
}
