variable "resource_group" {
  description = "The resource group postgres will be created in"
}

variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "vnet" {
  description = "The virtual network postgres will be created in"
}

variable "kubernetes_cluster" {

}

variable "database_type" {
  description = "The type of database"
  default     = "GP_Gen5_2"
}

variable "database_storage" {
  description = "The size of the database in MB"
  default     = 5120
}

variable "database_names" {
  description = "List of the database names"
  type        = list(string)
  default     = ["grafana", "test"]
}
