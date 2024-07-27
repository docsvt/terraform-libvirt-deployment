locals {
  deployment = yamldecode(file(var.deployment_definition_file != "" ? var.deployment_definition_file : "${path.module}/deployment.yaml"))

}


module "libvirt-lab" {
  source           = "github.com/docsvt/terraform-libvirt-deployment?ref=07216c9"
  cloud_images     = var.cloud_images
  nat_networks     = try(local.deployment.nat_networks, {})
  bridget_networks = try(local.deployment.bridget_networks, {})
  instances        = local.deployment.instances
}
