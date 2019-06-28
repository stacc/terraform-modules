output "client_id" {
  description = "The rbac client application ID of the app registrator"
  value       = "${azuread_application.client.application_id}"
}

output "server_id" {
  description = "The rbac server application ID of the app registrator"
  value       = "${azuread_application.server.application_id}"
}
output "server_secret" {
  description = "The rbac server service principal password"
  value       = "${azuread_service_principal_password.server.value}"
}
