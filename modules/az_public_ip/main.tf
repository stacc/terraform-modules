resource "azurerm_resource_group" "resource_group" {
  name     = "${var.name}-${var.environment}-public-ip-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
    managedBy   = "terraform"
  }
}

resource "azurerm_public_ip" "public_ip" {
  count               = "${var.count_public_ip}"
  name                = "${var.name}-${var.environment}-public-ip-${count.index + 1}"
  location            = "${azurerm_resource_group.resource_group.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  allocation_method   = "Static"

  tags = {
    environment = "${var.environment}"
    managedBy   = "terraform"
  }
}
