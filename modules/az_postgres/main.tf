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

resource "azurerm_postgresql_virtual_network_rule" "azure_svc_rule" {
  name                = "allow-all-azure-ips-vnet-rule"
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
    name     = "GP_Gen5_2"
    capacity = 2
    tier     = "GeneralPurpose"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "staccadmin"
  administrator_login_password = "${random_string.password.result}"
  version                      = "9.5"
  ssl_enforcement              = "Enabled"

  tags = {
    Environment = "${var.environment}"
  }
}

resource "azurerm_postgresql_database" "grafana" {
  name                = "grafana"
  resource_group_name = "${var.resource_group.name}"
  server_name         = "${azurerm_postgresql_server.server.name}"
  charset             = "UTF8"
  collation           = "English_United States.1252"
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
  length           = 16
  special          = true
  override_special = "/@\" "
}
