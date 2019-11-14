resource "azurerm_cosmosdb_account" "account" {
  name                = "${var.name}-${var.environment}-db-cosmos${var.account_name_suffix}"
  location            = "${var.resource_group.location}"
  resource_group_name = "${var.resource_group.name}"
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = "${var.enable_automatic_failover}"

  capabilities {
    name = "${var.capabilities}"
  }

  consistency_policy {
    consistency_level       = "${var.consistency_level}"
    max_interval_in_seconds = "${var.max_interval_in_seconds}"
    max_staleness_prefix    = "${var.max_staleness_prefix}"
  }

  geo_location {
    location          = "${var.failover_location}"
    failover_priority = 0
  }

  tags = {
    environment = "${var.environment}"
    managedBy   = "terraform"
  }
}

resource "azurerm_cosmosdb_mongo_database" "database" {
  count = length(var.database_names)
  name  = "${var.database_names[count.index]}"

  resource_group_name = "${var.resource_group.name}"
  account_name        = "${azurerm_cosmosdb_account.account.name}"
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
    name = "${var.name}-${var.environment}-db-cosmos${var.account_name_suffix}"
  }
  data = {
    connection-string = "${azurerm_cosmosdb_account.account.connection_strings[0]}"
  }
  type = "Opaque"
}
