output "public_ips" {
  description = "The public ips"
  value       = ["${azurerm_public_ip.public_ip.*.ip_address}"]
}

output "resource_group" {
  description = "The resource group of the public ip"
  value       = "${azurerm_resource_group.resource_group}"
}
