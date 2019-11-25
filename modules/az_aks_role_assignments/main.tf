provider "azurerm" {
  version = "~>1.33.0"
}

provider "azuread" {
  version = "~>0.6.0"
}

data "azurerm_client_config" "client_config" {}

resource "azurerm_role_assignment" "public_ip" {
  scope                = var.public_ip_rg_id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks_sp_object_id
}

resource "azurerm_role_assignment" "aks" {
  scope                = var.aks_rg_id
  role_definition_name = "Network Contributor"
  principal_id         = var.aks_sp_object_id
}

resource "azuread_group" "cluster_admins" {
  name = "s_${var.name}-${var.environment}_cluster_admins"
}

resource "azuread_group" "cluster_developers" {
  name = "s_${var.name}-${var.environment}_cluster_developers"
}

/*
  Public IP resource group
*/
resource "azurerm_role_assignment" "public_ip_admin_reader" {
  scope                = var.public_ip_rg_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.cluster_admins.id
}

resource "azurerm_role_assignment" "public_ip_user_reader" {
  scope                = var.public_ip_rg_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.cluster_developers.id
}

/*
  k8s resource group
*/
resource "azurerm_role_assignment" "aks_admin_admin" {
  scope                = var.aks_rg_id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = azuread_group.cluster_admins.id
}

resource "azurerm_role_assignment" "aks_admin_user" {
  scope                = var.aks_rg_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.cluster_admins.id
}

resource "azurerm_role_assignment" "aks_admin_contributor" {
  scope                = var.aks_rg_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.cluster_admins.id
}

resource "azurerm_role_assignment" "aks_developers_user" {
  scope                = var.aks_rg_id
  role_definition_name = "Azure Kubernetes Service Cluster User Role"
  principal_id         = azuread_group.cluster_developers.id
}

resource "azurerm_role_assignment" "aks_developers_reader" {
  scope                = var.aks_rg_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.cluster_developers.id
}

/*
  Database resource group
*/
resource "azurerm_role_assignment" "db_admin_contributor" {
  scope                = var.db_rg_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.cluster_admins.id
}

resource "azurerm_role_assignment" "db_developers_reader" {
  scope                = var.db_rg_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.cluster_developers.id
}

/*
  Storage account resource group
*/
resource "azurerm_role_assignment" "sa_admin_contributor" {
  scope                = var.sa_rg_id
  role_definition_name = "Contributor"
  principal_id         = azuread_group.cluster_admins.id
}

resource "azurerm_role_assignment" "sa_developers_reader" {
  scope                = var.sa_rg_id
  role_definition_name = "Reader"
  principal_id         = azuread_group.cluster_developers.id
}
