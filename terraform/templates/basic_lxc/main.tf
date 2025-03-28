terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "3.0.1-rc4" # avoid lxc start issue
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url != null ? var.pm_api_url : env("PM_API_URL")
  pm_tls_insecure = true
  pm_debug        = true
}

module "lxc" {
  source = "../modules/lxc"
  hostname = var.hostname
  target_node = var.target_node
  ostemplate = var.ostemplate
  root_password = var.root_password
  cores = var.cores
  memory = var.memory
  swap = var.swap
  storage = var.storage
  rootfs_size = var.rootfs_size
  bridge = var.bridge
  ip_address = var.ip_address
  gateway = var.gateway
  lxc_ssh_public_keys = var.lxc_ssh_public_keys
  create_lxc = var.create_lxc
  pm_api_url = var.pm_api_url
  use_dhcp = var.use_dhcp
  netmask = var.netmask
  tags = var.tags
  pve_user = var.pve_user
  pve_private_key = var.pve_private_key
  pve_host = var.pve_host
}

resource "null_resource" "ansible_setup" {
  provisioner "local-exec" {
    environment = {
      ANSIBLE_PRIVATE_KEY = var.lxc_ssh_private_key
      EXTRA_VARS = "package_installer_packages=${jsonencode(var.packages)}"
    }
    command = <<EOT
cat <<EOF > ../../ansible/inventory.ini
[my_servers]
lxc1 ansible_host=${module.lxc.ip_address}

[my_servers:vars]
ansible_user=root
EOF

CUR_DIR=$(pwd)
cd ../../ansible
chmod +x install.sh
./install.sh
cd $CUR_DIR
EOT
  }

  depends_on = [module.lxc]
}
