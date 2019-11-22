output "storage_share_url" {
  value = azurerm_storage_share.share.url
}

output "storage_share_id" {
  value = azurerm_storage_share.share.id
}

output "primary_connection_string" {
  value = "${azurerm_storage_account.sa.primary_connection_string}"
}
