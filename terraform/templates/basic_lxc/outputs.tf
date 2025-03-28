output "vmid" {
  value = module.lxc.vmid
}

output "ip_address" {
  description = "The IP address of the container"
  value       = module.lxc.ip_address
}

output "hostname" {
  value = module.lxc.hostname
}

output "lxc_ssh_public_keys" {
  value = module.lxc.lxc_ssh_public_keys
}
