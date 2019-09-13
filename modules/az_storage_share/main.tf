resource "azurerm_storage_account" "sa" {
  name                     = "${var.sa_name}"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.location}"
  account_tier             = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
  account_kind             = "FileStorage"
  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_share" "share" {
  name                 = "${var.share_name}"
  storage_account_name = "${azurerm_storage_account.sa.name}"
  quota                = "${var.quota}"
}