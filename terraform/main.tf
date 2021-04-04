# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "=2.19.0"
    }
  }
}

# #### ---------- Uncomment following blocks if you store your secrets in variables.tf file ----------- ####
# module "azure_init" {
#   source          = "./modules/init"

#   # Initial variables
#   tenant_id       = var.tenant_id
#   subscription_id = var.subscription_id
#   user_id         = var.user_id
#   user_secret     = var.user_secret
#   rg_region       = "Southeast Asia"
#   prefix          = "udacity_project"
# }

# module "azure_avset" {
#   source = "./modules/avset"

#   # Initial variables
#   tenant_id         = var.tenant_id
#   subscription_id   = var.subscription_id
#   user_id           = var.user_id
#   user_secret       = var.user_secret
#   rg_region         = "Southeast Asia"
#   prefix            = "udacity_project"
#   vm_count          = 3
#   admin_username    = var.admin_username
#   admin_password    = var.admin_password

#   current_rg_name   = module.azure_init.current_rg_name
#   current_rg_region = module.azure_init.current_rg_region
#   current_nsg_id    = module.azure_init.current_nsg_id
# }

#### --------- Uncomment following blocks if you use Hashicorp Vault for storing your secrets ----------- ####
# Configure the Hashicorp Vault provider
provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to use $VAULT_ADDR and $VAULT_TOKEN
}

data "vault_generic_secret" "service_principle" {
  path = "azure/service_test"
}

module "azure_init" {
  source          = "./modules/init"

  # Initial variables
  tenant_id       = data.vault_generic_secret.service_principle.data["tenant"]
  subscription_id = data.vault_generic_secret.service_principle.data["subscription"]
  user_id         = data.vault_generic_secret.service_principle.data["appId"]
  user_secret     = data.vault_generic_secret.service_principle.data["password"]
  rg_region       = "Southeast Asia"
  prefix          = "udacity_project"
}

module "azure_avset" {
  source = "./modules/avset"

  # Initial variables
  tenant_id         = data.vault_generic_secret.service_principle.data["tenant"]
  subscription_id   = data.vault_generic_secret.service_principle.data["subscription"]
  user_id           = data.vault_generic_secret.service_principle.data["appId"]
  user_secret       = data.vault_generic_secret.service_principle.data["password"]
  rg_region         = "Southeast Asia"
  prefix            = "udacity_project"
  vm_count          = 3
  admin_username    = var.admin_username
  admin_password    = var.admin_password

  current_rg_name   = module.azure_init.current_rg_name
  current_rg_region = module.azure_init.current_rg_region
  current_nsg_id    = module.azure_init.current_nsg_id
}