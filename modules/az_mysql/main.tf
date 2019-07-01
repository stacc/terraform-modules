resource "azurerm_resource_group" "mysql" {
  name     = "${var.name}-${var.environment}-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_network" "mysqlvnet" {
  name                = "mysql-vnet"
  location            = "${azurerm_resource_group.mysql.location}"
  resource_group_name = "${azurerm_resource_group.mysql.name}"
  address_space       = ["10.2.0.0/16"]

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_subnet" "mysqlsubnet" {
  name                 = "mysqlsubnet"
  resource_group_name  = "${azurerm_resource_group.mysql.name}"
  address_prefix       = "10.2.0.0/24"
  virtual_network_name = "${azurerm_virtual_network.mysqlvnet.name}"
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_mysql_server" "mysql" {
  name                = "${var.name}-${var.environment}-server-1"
  location            = "${azurerm_resource_group.mysql.location}"
  resource_group_name = "${azurerm_resource_group.mysql.name}"

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

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "5.7"
  ssl_enforcement              = "Enabled"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_mysql_database" "mysql" {
  name                = "db"
  resource_group_name = "${azurerm_resource_group.mysql.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_virtual_network_rule" "vnetrule" {
  name                = "mysql-vnet-rule"
  resource_group_name = "${azurerm_resource_group.mysql.name}"
  server_name         = "${azurerm_mysql_server.mysql.name}"
  subnet_id           = "${azurerm_subnet.mysqlsubnet.id}"
}
