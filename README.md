# Libvirt based project deploy module for terraform


## Variables

See variables.tf file

## Files

- main.tf - main terraform cofiguration file
- provider.tf - declare using libvirt provider
- variables.tf - declare variables
- output.tf - module exported values
- keys.tf - generate keys if not supplied
- templates/cloud_init.tftpl - template for cloud_init
- templates/network_config.tftpl - template for network configuration

## Bugs

When using bridge as type of libvirt_network, the provider may not return
the name of the network for the resource libvirt_domain, so terraform
cannot calculate right map { network_name => ip }
