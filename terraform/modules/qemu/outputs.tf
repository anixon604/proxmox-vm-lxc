output "vmid" {
  description = "The Proxmox VM IDs of the QEMU VMs"
  value       = proxmox_vm_qemu.vm[*].id
}

output "hostname" {
  description = "The names of the QEMU VMs"
  value       = proxmox_vm_qemu.vm[*].name
}

output "ip_address" {
  description = "The IP addresses configured via cloud-init"
  value       = proxmox_vm_qemu.vm[*].ipconfig0
}

output "ssh_user" {
  value = var.ciuser
}

output "ssh_public_key" {
  value = var.sshkeys
}
