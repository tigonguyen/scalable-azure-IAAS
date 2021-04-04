variable "tenant_id" {
  description = "The Tenant ID required for your organization"
  type        = string
  default     = "INSERT-YOUR-DATA-HERE"
}

variable "subscription_id" {
  description = "Specify the subscription for the project with ID"
  type        = string
  default     = "INSERT-YOUR-DATA-HERE"
}

variable "user_id" {
  description = "Specify the User/Service Principle linked to the subscription"
  type        = string
  default     = "INSERT-YOUR-DATA-HERE"
}

variable "user_secret" {
  description = "User/Service Principle password"
  type        = string
  default     = "INSERT-YOUR-DATA-HERE"
}

#### For VMs configuration
variable "admin_username" {
  description = "Define admin username for the entire project"
  type = string
  default = "adminUsername"
}

variable "admin_password" {
  description = "Define admin password for the entire project"
  type = string
  default = "Password@1234"
}
