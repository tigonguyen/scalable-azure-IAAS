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
