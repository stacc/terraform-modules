provider "azurerm" {
  version = "~>1.29"
}

resource "azurerm_resource_group" "tf_rg" {
  name     = "${var.name}-tf-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_account" "tf_sa" {
  name                     = "${var.name}-tf-sa"
  resource_group_name      = "${azurerm_resource_group.tf_rg.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.environment}"
  }
}
resource "azurerm_storage_container" "tf_sc" {
  name                  = "${var.name}-tf-sc"
  resource_group_name   = "${azurerm_resource_group.tf_rg.name}"
  storage_account_name  = "${azurerm_storage_account.tf_sa.name}"
  container_access_type = "private"
}
