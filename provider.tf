terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
  required_version = "~> 1.9"
}

provider "libvirt" {
  uri = "qemu:///system"
}
