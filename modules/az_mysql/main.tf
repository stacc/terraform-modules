resource "azurerm_subnet" "mysqlsubnet" {
  name                 = "mysqlsubnet"
  resource_group_name  = "${var.vnet.resource_group_name}"
  address_prefix       = "10.1.129.0/24"
  virtual_network_name = "${var.vnet.name}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_mysql_virtual_network_rule" "vnetrule" {
  name                = "mysql-vnet-rule"
  resource_group_name = "${var.resource_group.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  subnet_id           = "${azurerm_subnet.mysqlsubnet.id}"
}

resource "azurerm_mysql_firewall_rule" "azure_svc_rule" {
  name                = "allow-all-azure-ips-fw-rule"
  resource_group_name = "${var.resource_group.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_server" "mysql" {
  name                = "${var.name}-${var.environment}-db-mysql"
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
  version                      = "5.7"
  ssl_enforcement              = "Enabled"

  tags = {
    environment = "${var.environment}"
    managedBy   = "terraform"
  }
}

resource "azurerm_mysql_database" "databases" {
  count               = length(var.database_names)
  name                = "${var.database_names[count.index]}"
  resource_group_name = "${var.resource_group.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
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
    name = "${var.name}-${var.environment}-db-mysql"
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
