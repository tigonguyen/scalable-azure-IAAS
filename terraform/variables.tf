# ------- Variables for configuring VM -------- #
variable "prefix" {
  description = "Prefix value for sync up resource data"
  type = string
  default = "scalable-iaas"
}

variable "hostname" {
  description = "Hostname of the VM"
  type = string
  default = "webserver"
}

variable "host_username" {
  description = "Username for the VM access"
  type = string
  default = "adminUsername"
}

variable "host_password" {
  description = "Password for the VM access"
  type = string
  default = "Password@1234"
}

