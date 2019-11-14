output "kubernetes_cluster" {
  value = azurerm_kubernetes_cluster.kubernetes
}

output "kubernetes_cluster_admin_group_id" {
  value = azuread_group.cluster_admins.id
}
