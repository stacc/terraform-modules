output "password" {
  description = "The client password"
  value       = random_string.application_client_password.result
}

output "app_id" {
  description = "The application id"
  value       = azuread_application.application.application_id
}

output "client_id" {
  description = "The client id"
  value       = azuread_service_principal.application_client.id
}
