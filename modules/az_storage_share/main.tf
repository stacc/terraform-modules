resource "azurerm_storage_account" "sa" {
  name                     = "${var.sa_name}"
  resource_group_name      = "${var.rg_name}"
  location                 = "${var.location}"
  account_tier             = "${var.account_tier}"
  account_replication_type = "${var.account_replication_type}"
  account_kind             = "FileStorage"
  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_storage_share" "share" {
  name                 = "${var.share_name}"
  storage_account_name = "${azurerm_storage_account.sa.name}"
  quota                = "${var.quota}"
}

provider "kubernetes" {
  version                = "1.7"
  load_config_file       = false
  host                   = "${var.kubernetes_cluster.kube_admin_config.0.host}"
  client_certificate     = "${base64decode(var.kubernetes_cluster.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(var.kubernetes_cluster.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(var.kubernetes_cluster.kube_admin_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_secret" "filestorage-secret" {
  metadata {
    name = "${var.sa_name}-${var.environment}-filestorage"
  }
  data = {
    azurestorageaccountname = "${var.sa_name}"
    azurestorageaccountkey  = "${azurerm_storage_account.sa.primary_access_key}"
  }
  type = "Opaque"
}

resource "kubernetes_persistent_volume" "filestorage" {
  metadata {
    name = "${var.sa_name}-${var.environment}-filestorage-pv"
  }
  spec {
    capacity = {
      storage = "200Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      azure_file {
        read_only   = false
        secret_name = "${kubernetes_secret.filestorage-secret.secret_name}"
        share_name  = "${var.share_name}"
      }
    }
  }
}
