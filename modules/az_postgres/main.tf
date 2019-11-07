resource "azurerm_postgresql_firewall_rule" "azure_svc_rule" {
  name                = "allow-all-azure-ips-fw-rule"
  resource_group_name = "${var.resource_group.name}"
  server_name         = "${azurerm_postgresql_server.server.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_postgresql_server" "server" {
  name                = "${var.name}-${var.environment}-db-postgres"
  location            = "${var.resource_group.location}"
  resource_group_name = "${var.resource_group.name}"

  sku {
    name     = "${var.database_type}"
    capacity = "${var.database_capacity}"
    tier     = "${var.database_tier}"
    family   = "${var.database_family}"
  }

  storage_profile {
    storage_mb            = "${var.database_storage}"
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "staccadmin"
  administrator_login_password = "${random_string.password.result}"
  version                      = "${var.database_version}"
  ssl_enforcement              = "Enabled"

  tags = {
    environment = "${var.environment}"
    managedBy   = "terraform"
  }
}

provider "kubernetes" {
  version                = "1.7"
  load_config_file       = false
  host                   = "${var.kubernetes_cluster.kube_admin_config.0.host}"
  client_certificate     = "${base64decode(var.kubernetes_cluster.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(var.kubernetes_cluster.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(var.kubernetes_cluster.kube_admin_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_secret" "database_secret" {
  metadata {
    name      = "${var.name}-${var.environment}-db-postgres"
    namespace = "default"
  }
  data = {
    login_host     = "${azurerm_postgresql_server.server.fqdn}"
    login_user     = "staccadmin@${var.name}-${var.environment}-db-postgres"
    login_password = "${random_string.password.result}"
    resource_group = "${var.resource_group.name}"
    server_name    = "${var.name}-${var.environment}-db-postgres"
  }
  type = "Opaque"
}

resource "random_string" "password" {
  length      = 16
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  special     = false
}
