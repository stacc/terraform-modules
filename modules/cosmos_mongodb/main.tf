resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.name}-${var.environment}-cosmosdb"
  location            = "${var.resource_group.location}"
  resource_group_name = "${var.resource_group.name}"
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    prefix            = "${var.name}-${var.environment}-cosmosdb-1"
    location          = "${var.resource_group.location}"
    failover_priority = 0
  }

  tags = {
    Environment = "${var.environment}"
  }
}
