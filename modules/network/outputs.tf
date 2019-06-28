output "virtual_network" {
  description = "The virtual network created"
  value       = "${azurerm_virtual_network.vnet}"
}
