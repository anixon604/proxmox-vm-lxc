terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "proxmox_vm_qemu" "vm" {
  depends_on = [
    null_resource.cloud_init_config_files,
  ]

  count = var.create_vm ? 1 : 0
  name        = var.name
  target_node = var.target_node
  agent       = 1
  cores       = var.cores
  sockets     = var.sockets
  memory      = var.memory
  boot        = "order=virtio0" # has to be the same as the OS disk of the template
  clone       = var.clone
  scsihw      = "virtio-scsi-single"
  vm_state    = "running"
  automatic_reboot = true

  # Cloud-Init configuration
  cicustom   = "vendor=local:snippets/user_data_${var.name}.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
  ciupgrade  = true
  ciuser     = var.ciuser
  cipassword = var.cipassword
  sshkeys    = var.sshkeys
  ipconfig0  = var.use_dhcp ? "ip=dhcp" : "ip=${var.ip_address}/${var.netmask},gw=${var.gateway}"
  skip_ipv6  = true

  # Most cloud-init images require a serial device for their display
  serial {
    id = 0
  }

  disks {
    virtio {
      virtio0 {
        # We have to specify the disk from our template, else Terraform will think it's not supposed to be there
        disk {
          storage = var.storage
          # The size of the disk should be at least as big as the disk in the template. If it's smaller, the disk will be recreated
          size    = var.disk_size
        }
      }
    }
    ide {
      # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
      ide2 {
        cloudinit {
          storage = "local-zfs"
        }
      }
    }
  }

  network {
    id = 0
    bridge = var.bridge
    model  = "virtio"
  }

  tags = join(",", compact(concat(["managed-by-terraform"], var.tags != null ? var.tags : [])))
}
