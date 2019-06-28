provider "azurerm" {
  version = "~>1.29"
}

resource "azurerm_resource_group" "tfstaterg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_storage_account" "tfstatesa" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${azurerm_resource_group.tfstaterg.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment}"
  }
}
resource "azurerm_storage_container" "tfstatesc" {
  name                  = "${var.storage_container_name}"
  resource_group_name   = "${azurerm_resource_group.tfstaterg.name}"
  storage_account_name  = "${azurerm_storage_account.tfstatesa.name}"
  container_access_type = "private"
}
output "account_access_key" {
  value = "${azurerm_storage_account.tfstatesa.primary_access_key}"
}
