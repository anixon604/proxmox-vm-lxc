variable "name" {
  description = "The name of the VM"
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to deploy the VM on"
  type        = string
}

variable "clone" {
  description = "The name of the VM template to clone"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in MB"
  type        = number
}

variable "disk_size" {
  description = "Disk size, e.g., 20G"
  type        = string
  default     = "4G"
}

variable "storage" {
  description = "Storage pool name, e.g., local-lvm"
  type        = string
}

variable "bridge" {
  description = "Bridge to attach the VM network interface to"
  type        = string
}

variable "ciuser" {
  description = "Username to create via cloud-init"
  type        = string
}

variable "cipassword" {
  description = "Password for the cloud-init user"
  type        = string
  sensitive   = true
}

variable "sshkeys" {
  description = "Public SSH key(s) to inject via cloud-init"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "Static IP address (required if use_dhcp is false)"
  type        = string
  default     = null
}

variable "netmask" {
  description = "Subnet mask CIDR (required if use_dhcp is false)"
  type        = number
  default     = null
}

variable "gateway" {
  description = "Default gateway (required if use_dhcp is false)"
  type        = string
  default     = null
}

variable "create_vm" {
  description = "Whether to create the VM"
  type        = bool
  default     = true
}

variable "use_dhcp" {
  description = "Whether to use DHCP for network configuration"
  type        = bool
  default     = false
}

locals {
  network_validation = var.use_dhcp || (var.ip_address != null && var.netmask != null && var.gateway != null)
}

check "network_configuration" {
  assert {
    condition     = local.network_validation
    error_message = "Either use_dhcp must be true, or ip_address, netmask, and gateway must all be provided"
  }
}

variable "packages" {
  description = "List of packages to install on the VM"
  type        = list(string)
  default     = ["qemu-guest-agent"]
}

variable "pve_user" {
  description = "Proxmox username"
  type        = string
  default     = "root"
}

variable "pve_private_key" {
  description = "Proxmox private key"
  type        = string
  sensitive   = true
}

variable "pve_host" {
  description = "Proxmox host"
  type        = string
  default     = "pve"
}

variable "tags" {
  description = "Additional tags to add to the VM"
  type        = list(string)
  default     = []
}

variable "apt_cacher_ng_endpoint" {
  description = "The endpoint URL for apt-cacher-ng (e.g., http://10.20.88.2:3142)"
  type        = string
  default     = null
}
