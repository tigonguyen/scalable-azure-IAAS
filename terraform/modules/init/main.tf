terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.user_id
  client_secret   = var.user_secret
  tenant_id       = var.tenant_id
}

# Create resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}_rg" # resource group name
  location = var.rg_region # Azure region
}

# Create VNET
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}_vnet" 
  location            = var.rg_region  # Azure region
  resource_group_name = azurerm_resource_group.main.name # resource group name
  address_space       = [ "10.0.0.0/16" ]
}

# Create network security group
resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}_nsg"
  location            = var.rg_region
  resource_group_name = azurerm_resource_group.main.name
  security_rule {
    name                       = "${var.prefix}_allowVNet_Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VNet"
    destination_address_prefix = "VNet"
  }
  security_rule {
    name                       = "${var.prefix}_allowVNet-Outbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VNet"
    destination_address_prefix = "VNet"
  }
}