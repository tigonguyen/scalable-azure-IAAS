variable "tenant_id" {
  description = "The Tenant ID required for your organization"
  type       = string
}

variable "subscription_id" {
  description = "Specify the subscription for the project with ID"
  type       = string
}

variable "user_id" {
  description = "Specify the User/Service Principle linked to the subscription"
  type       = string
}

variable "user_secret" {
  description = "User/Service Principle password"
  type       = string
}

variable "rg_region" {
  description = "Specify where the related RG located"
  type        = string
}

variable "prefix" {
  description = "Specify a prefix for naming during entire the project"
  type        = string
}

variable "vm_count" {
  description = "Specify the number of instances in set"
  type        = number
}

variable "admin_username" {
  description = "Username for the VM access"
  type = string
}

variable "admin_password" {
  description = "Password for the VM access"
  type = string
}

### -------- variables received data from other modules -------- ###
variable "current_rg_name" {
  description = "Name of the current resource group"
  type        = string
}

variable "current_rg_region" {
  description = "Region of the current resource group"
  type        = string
}

variable "current_nsg_id" {
  description = "ID of the current NSG"
  type        = string
}

variable "current_subnet_id" {
  description = "Network ID in the current project"
  type        = string
}
