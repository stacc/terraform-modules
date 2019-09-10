data "azurerm_client_config" "client_config" {}

resource "azurerm_role_assignment" "public_ip" {
  principal_id         = "${module.service-principle.object_id}"
  role_definition_name = "Network Contributor"
  scope                = "${var.public_ip_rg.id}"
}

resource "azurerm_role_assignment" "aks" {
  scope                = "${var.resource_group.id}"
  role_definition_name = "Network Contributor"
  principal_id         = "${module.service-principle.object_id}"
}

resource "azuread_group" "cluster_admins" {
  name = "s_${var.name}-${var.environment}_cluster_admins"
}

resource "azuread_group" "cluster_developers" {
  name = "s_${var.name}-${var.environment}_cluster_developers"
}
