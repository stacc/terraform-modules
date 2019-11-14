output "flow_password" {
  description = "The grafana client password"
  value       = "random_string.application_client_password.result"
}

output "flow_app_id" {
  description = "The grafana application id"
  value       = "azuread_application.flow.application_id"
}

output "flow_client_id" {
  description = "The grafana client id"
  value       = "azuread_service_principal.flow_client.id"
}
