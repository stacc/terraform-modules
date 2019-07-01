provider "azurerm" {
  version = "~>1.29"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-acr-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  sku                 = "Standard"
  admin_enabled       = false

  tags = {
    environment = "${var.environment}"
  }
}
