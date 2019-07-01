output "account_access_key" {
  description = "The storage account primary access key"
  value = "${azurerm_storage_account.tf_sa.primary_access_key}"
}
