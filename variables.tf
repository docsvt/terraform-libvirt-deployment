variable "cloud_images" {
  description = "Base cloud image locations"
  type        = map(string)
}

# Seed enviroment
variable "environment" {
  description = "Deployment identification"
  type        = string
  default     = "default"
}


variable "nat_networks" {
  description = "Networks definition"
  type = map(any)
  default = {}
}

variable "bridget_networks" {
  description = "Networks definition"
  type = map(any)
  default = {}
}

variable "instances" {
  description = "Instances definition"
  type = map(any)
}


variable "private_ssh_key_path" {
  type        = string
  description = "ssh private key path"
  default     = ""
}

variable "public_ssh_key_path" {
  type        = string
  description = "ssh private key path"
  default     = ""
}

variable "vm_admin_user" {
  type        = string
  description = "Default administrative user for VM"
  default     = "sa"
}

variable "vm_admin_user_password" {
  type        = string
  description = "Default administrative user for VM"
  default =""
}

variable "default_qemu_agent" {
  type        = string
  description = ""
  default     = "true"
}

# # kvm disk pool name
variable "default_disk_pool" {
  type        = string
  description = ""
  default     = "default"
}

# Defaults for networks
# kvm standard default network
variable "dns_domain" {
  type        = string
  description = ""
  default     = "localdomain"
}

variable "dns_forwarder" {
  type        = string
  description = ""
  default     = "127.0.0.53"
}
