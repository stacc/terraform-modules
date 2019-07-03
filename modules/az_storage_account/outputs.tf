output "account_access_key" {
  description = "The storage account primary access key"
  value = "${azurerm_storage_account.sa.primary_access_key}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.rg.name}"
}

output "container_name" {
  value = "${azurerm_storage_container.sc.name}"
}
