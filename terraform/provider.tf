# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    vault = {
      source = "hashicorp/vault"
      version = "=2.19.0"
    }
  }
}

# Configure the Hashicorp Vault provider
provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR and $VAULT_TOKEN
}

data "vault_generic_secret" "service_principle" {
  path = "azure/service_test"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  subscription_id = data.vault_generic_secret.service_principle.data["subscription"]
  client_id = data.vault_generic_secret.service_principle.data["appId"]
  client_secret = data.vault_generic_secret.service_principle.data["password"]
  tenant_id = data.vault_generic_secret.service_principle.data["tenant"]
}