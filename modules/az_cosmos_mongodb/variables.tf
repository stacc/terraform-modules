variable "resource_group" {
  description = "The resource group the database should be created in"
}

variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "enable_automatic_failover" {
  default     = true
}

variable "consistency_level" {
  description = "The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix"
  default     = "BoundedStaleness"
}
variable "max_interval_in_seconds" {
  description = "When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Accepted range for this value is 5 - 86400 (1 day). Defaults to 5. Required when consistency_level is set to BoundedStaleness"
  default     = 10
}
variable "max_staleness_prefix" {
  description = "When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Accepted range for this value is 10 – 2147483647. Defaults to 100. Required when consistency_level is set to BoundedStaleness"
  default     = 200
}

variable "database_names" {
  description = "List of the database names"
  type        = list(string)
  default     = ["test"]
}

variable "unique_key" {
  default     = "uniqueKey"
}