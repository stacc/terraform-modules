output "grafana_password" {
  description = "The grafana client password"
  value       = random_string.application_client_password.result
}

output "grafana_app_id" {
  description = "The grafana application id"
  value       = azuread_application.grafana.application_id
}

output "grafana_client_id" {
  description = "The grafana client id"
  value       = azuread_service_principal.grafana_client.id
}
