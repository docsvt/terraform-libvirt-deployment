# Output definitions for terraform lab
output "sa_user" {
  value     = module.libvirt-lab.sa_user
  sensitive = true
}

output "ssh_key_pair" {
  value     = module.libvirt-lab.ssh_key_pair
  sensitive = true
}

output "instances" {
  value = module.libvirt-lab.instances
}
