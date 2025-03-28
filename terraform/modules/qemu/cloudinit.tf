resource "local_file" "cloud_init_user_data_file" {
  count    = var.create_vm ? 1 : 0
  content  = templatefile("${path.module}/cloud-inits/cloud-init.cloud_config.tftpl", {
    packages = var.packages
  })
  filename = "${path.module}/files/user_data_${count.index}.cfg"
}

resource "null_resource" "cloud_init_config_files" {
  count = var.create_vm ? 1 : 0
  connection {
    type     = "ssh"
    user     = "${var.pve_user}"
    private_key = file("${var.pve_private_key}")
    host     = "${var.pve_host}"
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[count.index].filename
    destination = "/var/lib/vz/snippets/user_data_${var.name}.yml"
  }
}
