locals {


  os_images = distinct([for instance in var.instances : tostring(instance.image)])

  private_ssh_key = var.private_ssh_key_path != "" ? file(var.private_ssh_key_path) : tls_private_key.this[0].private_key_openssh

  public_ssh_key = var.public_ssh_key_path != "" ? file(var.public_ssh_key_path) : tls_private_key.this[0].public_key_openssh

  vm_admin_user_password = var.vm_admin_user_password != "" ? var.vm_admin_user_password : random_password.this[0].result

}

resource "libvirt_volume" "os_base" {
  # Durty workaround to use list(dynamic) if for_each construct
  for_each = tomap({
    for i in local.os_images :
    i => i
  })

  name   = "${var.environment}-${each.key}-base.qcow2"
  pool   = var.default_disk_pool
  source = var.cloud_images[each.key]
  format = "qcow2"
}


resource "libvirt_volume" "root_volume" {
  for_each = var.instances

  name           = "${var.environment}-${each.key}.qcow2"
  pool           = try(each.value.pool, var.default_disk_pool)
  base_volume_id = libvirt_volume.os_base[each.value.image].id
  size           = each.value.size
}


# # Generate cloudinit disk
resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each = var.instances

  name = "${var.environment}-${each.key}-cloudinit.iso"
  pool = try(each.value.pool, var.default_disk_pool)
  user_data = templatefile("${path.module}/templates/cloud_init.tftpl",
    {
      hostname            = each.key
      fqdn                = "${each.key}.${var.dns_domain}"
      password            = local.vm_admin_user_password
      user                = var.vm_admin_user
      ssh_authorized_keys = [local.public_ssh_key]

  })
  network_config = templatefile("${path.module}/templates/network_config_v${each.value.network_config_version}.tftpl",
    {
      networks = each.value.networks,
      domain   = try(each.value.domain, var.dns_domain)
  })
}

# Create the instance
resource "libvirt_domain" "instances" {
  for_each = var.instances

  # domain name in libvirt, not hostname
  name       = "${var.environment}-${each.key}"
  memory     = each.value.memoryGB * 1024
  vcpu       = each.value.vcpu
  qemu_agent = try(each.value.qemu_agent, var.default_qemu_agent)
  cpu {
    mode = "host-passthrough"
  }

  disk { volume_id = libvirt_volume.root_volume[each.key].id }

  dynamic "network_interface" {
    for_each = each.value.networks
    content {
      network_name   = "${var.environment}-${network_interface.key}"
      wait_for_lease = true
    }
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit[each.key].id

  # IMPORTANT
  # Ubuntu can hang is a isa-serial is not present at boot time.
  # If you find your CPU 100% and never is available this is why
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = "true"
  }
}
