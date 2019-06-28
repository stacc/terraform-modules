resource "azurerm_virtual_network" "vnet" {
  name                = "${var.name}-${var.environment}-vnet"
  location            = "${var.resource_group.location}"
  resource_group_name = "${var.resource_group.name}"
  address_space       = ["10.1.0.0/16"]
}
