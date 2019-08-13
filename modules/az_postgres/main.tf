resource "azurerm_subnet" "postgressubnet" {
  name                 = "postgressubnet"
  resource_group_name  = "${var.resource_group.name}"
  address_prefix       = "10.1.128.0/24"
  virtual_network_name = "${var.vnet.name}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_postgresql_virtual_network_rule" "vnet_rule" {
  name                                 = "postgresql-vnet-rule"
  resource_group_name                  = "${var.resource_group.name}"
  server_name                          = "${azurerm_postgresql_server.server.name}"
  subnet_id                            = "${azurerm_subnet.postgressubnet.id}"
  ignore_missing_vnet_service_endpoint = true
}

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
    tier     = "GeneralPurpose"
    family   = "Gen5"
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
  }
}

resource "azurerm_postgresql_database" "databases" {
  count               = length(var.database_names)
  name                = "${var.database_names[count.index]}"
  resource_group_name = "${var.resource_group.name}"
  server_name         = "${azurerm_postgresql_server.server.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
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
    name = "${var.name}-${var.environment}-db-postgres"
  }
  data = {
    password = "${random_string.password.result}"
  }
  type = "Opaque"
}

resource "random_string" "password" {
  length  = 16
  special = false
}
