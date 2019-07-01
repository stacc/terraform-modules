output "account_access_key" {
  description = "The storage account primary access key"
  value = "${azurerm_storage_account.tf_sa.primary_access_key}"
}

output "resource_group_name" {
  value = "${azurerm_resource_group.tf_rg.name}"
}

output "container_name" {
  value = "${azurerm_storage_container.tf_sc.name}"
}
