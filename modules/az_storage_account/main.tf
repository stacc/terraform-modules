provider "azurerm" {
  version = "~>1.29"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${var.sa_name}"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment}"
  }
}
resource "azurerm_storage_container" "storage_container" {
  count                 = length(var.storage_containers)
  name                  = "${var.storage_containers[count.index]}"
  resource_group_name   = "${var.rg_name}"
  storage_account_name  = "${azurerm_storage_account.storage_account.name}"
  container_access_type = "private"
}
