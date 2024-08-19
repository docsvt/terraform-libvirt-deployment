locals {
  deployment = yamldecode(file(var.deployment_definition_file != "" ? var.deployment_definition_file : "${path.module}/deployment.yaml"))

}


module "libvirt-lab" {
  source = "../"
  #source           = "github.com/docsvt/terraform-libvirt-deployment?ref=07216c9"
  cloud_images     = var.cloud_images
  nat_networks     = try(local.deployment.nat_networks, {})
  bridget_networks = try(local.deployment.bridget_networks, {})
  instances        = local.deployment.instances
  dns_domain       = var.dns_domain
}

resource "terraform_data" "ssh_key_pair" {
  triggers_replace = {
    ssh_key_pair = module.libvirt-lab.ssh_key_pair
  }
    # when creating, pipe the private key value to the localhost ~/.ssh directory
  provisioner "local-exec" {
    # create a new one, chmod permissions of the new key, add to key chain
    when    = create
    command = "echo '${module.libvirt-lab.ssh_key_pair.private_ssh_key}' > ~/.ssh/${self.id}.pem; chmod 0400 ~/.ssh/${self.id}.pem"
  }

  # When this resources is destroyed, delete the associated key from the file system
  provisioner "local-exec" {
    when    = destroy
    command = "rm ~/.ssh/${self.id}.pem"
  }

}
