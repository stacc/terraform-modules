output "sa_name" {
  value = "${var.sa_name}"
}

output "access_key" {
  description = "The storage account primary access key"
  value = "${azurerm_storage_account.storage_account.primary_access_key}"
}

output "container_name" {
  value = "${azurerm_storage_container.storage_container.name}"
}

output "primary_connection_string" {
  value = "${azurerm_storage_account.storage_account.primary_connection_string}"
}
