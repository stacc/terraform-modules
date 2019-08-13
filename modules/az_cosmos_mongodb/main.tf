resource "azurerm_cosmosdb_account" "account" {
  name                = "${var.name}-${var.environment}-cosmos-account"
  location            = "${var.resource_group.location}"
  resource_group_name = "${var.resource_group.name}"
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = "${var.enable_automatic_failover}"

  consistency_policy {
    consistency_level       = "${var.consistency_level}"
    max_interval_in_seconds = "${var.max_interval_in_seconds}"
    max_staleness_prefix    = "${var.max_staleness_prefix}"
  }

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_cosmosdb_mongo_database" "database" {
  name                = "${var.name}-${var.environment}-mongo-db"
  resource_group_name = "${var.resource_group.name}"
  account_name        = "${azurerm_cosmosdb_account.db.name}"
}

resource "azurerm_cosmosdb_mongo_collection" "collection" {
  count               = length(var.database_names)
  name                = "${var.database_names[count.index]}"
  
  resource_group_name = "${var.resource_group.name}"
  account_name        = "${azurerm_cosmosdb_account.db.name}"
  database_name       = "${azurerm_cosmosdb_mongo_database.example.name}"

  default_ttl_seconds = "-1"
  shard_key           = "${var.unique.key}"

  indexes {
    key    = "${var.unique.key}"
    unique = true
  }
}