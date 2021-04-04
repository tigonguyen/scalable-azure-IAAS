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

# Create NICs for instances in the avset
resource "azurerm_network_interface" "main" {
  count               = var.vm_count
  name                = "nic-${count.index}"
  resource_group_name = var.current_rg_name
  location            = var.current_rg_region

  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
  }
}

# Connect NICs to the current NSG 
resource "azurerm_network_interface_security_group_association" "nic_sec_assoc" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.main[count.index].id
  network_security_group_id = var.current_nsg_id
}

# Create a public IP for LB frontend_ip
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}_lb_frontend_ip"
  resource_group_name = var.current_rg_name
  location            = var.current_rg_region
  allocation_method   = "Static"
}

# Create a Load Balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}_lb"
  resource_group_name = var.current_rg_name
  location            = var.current_rg_region
  frontend_ip_configuration {
    name                 = "${var.prefix}_frontend_ip_config"
    public_ip_address_id = azurerm_public_ip.main.id
  }
}

# Create a backend address pool for the LB
resource "azurerm_lb_backend_address_pool" "main" {
  name                = "${var.prefix}_backend_address_pool"
  resource_group_name = var.current_rg_name
  loadbalancer_id     = azurerm_lb.main.id
}

# Connect NICs to LB address pool
resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.vm_count
  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

resource "azurerm_availability_set" "main" {
  name                         = "${var.prefix}_avset"
  resource_group_name          = var.current_rg_name
  location                     = var.current_rg_region
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

# Get data of the image
data "azurerm_image" "main" {
  name = "webPackerImage"
  resource_group_name = "scalable-iaas"
}

# Create VMs in the avset
resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.vm_count
  name                            = "${var.prefix}-${count.index}-vm"
  resource_group_name             = var.current_rg_name
  location                        = var.current_rg_region
  size                            = "Standard_A2"
  availability_set_id             = azurerm_availability_set.main.id
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [element(azurerm_network_interface.main.*.id, count.index)]
  source_image_id                 = data.azurerm_image.main.id
  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}