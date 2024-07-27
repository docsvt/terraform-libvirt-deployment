# Output definitions for terraform lab
output "sa_user" {
  value     = { "${var.vm_admin_user}" = local.vm_admin_user_password }
  sensitive = true
}

output "ssh_key_pair" {
  value = {
    "private_ssh_key" = local.private_ssh_key,
    "public_ssh_key" = local.public_ssh_key
  }
  sensitive = true
}

output "instances" {
  value = libvirt_domain.instances
}
