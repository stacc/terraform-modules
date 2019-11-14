provider "kubernetes" {
  version                = "1.7"
  load_config_file       = false
  host                   = "azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.host"
  client_certificate     = "base64decode(azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.client_certificate)"
  client_key             = "base64decode(azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.client_key)"
  cluster_ca_certificate = "base64decode(azurerm_kubernetes_cluster.kubernetes.kube_admin_config.0.cluster_ca_certificate)"
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "stacc-cluster-admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "azuread_group.cluster_admins.id"
    api_group = "rbac.authorization.k8s.io"
  }
}
