variable "hostname" {
  description = "The container hostname"
  type        = string
}

variable "target_node" {
  description = "The Proxmox node to deploy the LXC container on"
  type        = string
}

variable "ostemplate" {
  description = "The LXC template to use for cloning"
  type        = string
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
}

variable "memory" {
  description = "Memory in MB"
  type        = number
}

variable "swap" {
  description = "Swap memory in MB"
  type        = number
  default     = 512
}

variable "storage" {
  description = "Storage pool and size, e.g., local-lvm:8G"
  type        = string
}

variable "rootfs_size" {
  description = "Root filesystem size, e.g., 8G"
  type        = string
}

variable "network_name" {
  description = "Name of the LXC network interface"
  type        = string
  default     = "eth0"
}

variable "bridge" {
  description = "Bridge to attach the container network interface to"
  type        = string
}

variable "ip_address" {
  description = "Static IP address for the container"
  type        = string
  default     = null
}

variable "gateway" {
  description = "Default gateway for the container"
  type        = string
  default     = null
}

variable "netmask" {
  description = "Netmask for the container"
  type        = string
  default     = null
}

variable "lxc_ssh_public_keys" {
  description = "Public SSH key(s) to inject into container"
  type        = string
  default     = ""
}

variable "lxc_ssh_private_key" {
  description = "Path to private SSH key to inject into container"
  type        = string
  sensitive   = true
}

variable "root_password" {
  description = "Root password for the container"
  type        = string
  sensitive   = true
}

variable "create_lxc" {
  description = "Whether to create the LXC container"
  type        = bool
  default     = true
}

variable "use_dhcp" {
  description = "Whether to use DHCP for network configuration"
  type        = bool
  default     = true
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

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "tags" {
  description = "Additional tags to add to the container"
  type        = list(string)
  default     = []
}

variable "pve_user" {
  description = "Proxmox username"
  type        = string
  default     = "root"
}

variable "pve_host" {
  description = "Proxmox host"
  type        = string
  default     = "pve"
}

variable "pve_private_key" {
  description = "Proxmox private key"
  type        = string
  sensitive   = true
}

variable "apt_cacher_ng_endpoint" {
  description = "The endpoint URL for apt-cacher-ng (e.g., http://10.20.88.2:3142)"
  type        = string
  default     = null
}

