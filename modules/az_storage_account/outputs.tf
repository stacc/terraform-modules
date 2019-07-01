output "account_access_key" {
  value = "${azurerm_storage_account.tf_sc.primary_access_key}"
}
