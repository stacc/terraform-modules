output "service_principal_id" {
  value = "azuread_service_principal.service_principal.id"
}

output "client_id" {
  value = "azuread_service_principal.service_principal.application_id"
}

output "client_secret" {
  value = "azuread_service_principal_password.service_principal_password.value"
}

output "object_id" {
  value = "azuread_service_principal.service_principal.object_id"
}
