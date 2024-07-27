variable "deployment_definition_file" {
  description = "Deployment file"
  type        = string
  default     = ""
}


variable "cloud_images" {
  description = "Base cloud image locations"
  type        = map(string)
}

# Seed enviroment
variable "seedenv" {
  type        = string
  description = "Enviroment identification"
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
