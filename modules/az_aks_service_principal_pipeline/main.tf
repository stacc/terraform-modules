provider "azuread" {
  version = "~>0.6.0"
}

resource "azuread_application" "pipline" {
  name = "${var.name}-${var.environment}-pipline"
}

resource "azuread_service_principal" "pipline_sp" {
  application_id = azuread_application.pipline.application_id
}

resource "azuread_group_member" "pipline_member" {
  group_object_id  = var.group_object_id
  member_object_id = azuread_service_principal.pipline_sp.id
}
