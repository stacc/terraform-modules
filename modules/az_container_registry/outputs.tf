output "login_server" {
  description = "URL of ACR"
  value = "azurerm_container_registry.acr.login_server"
}
output "acr" {
  description = "ACR object"
  value = "azurerm_container_registry.acr"
}
