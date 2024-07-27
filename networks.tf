# Buid overall network configuration
resource "libvirt_network" "nat" {
  for_each = var.nat_networks
  name     = "${var.environment}-${each.key}"
  # nat|none|route|bridge
  mode      = "nat"
  addresses = each.value.addresses
  domain    = try(each.value.dns_domain, var.dns_domain)

  dns {
    enabled    = true
    local_only = false
    forwarders { address = try(each.value.dns_forwarder, var.dns_forwarder) }
  }
  dhcp { enabled = true }
  autostart = true
}


resource "libvirt_network" "bridge" {
  for_each = var.bridget_networks
  name     = "${var.environment}-${each.key}"
  # nat|none|route|bridge
  mode      = "bridge"
  bridge    = each.value.bridge

  dns {
    enabled    = true
    local_only = false
    forwarders { address = try(each.value.dns_forwarder, var.dns_forwarder) }
  }
  dhcp { enabled = true }
  autostart = true
}
