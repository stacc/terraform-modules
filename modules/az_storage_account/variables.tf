variable "name" {
  default = "stacc"
}

variable "sa_name" {
  description = "A unique name for the storage account"
  default = "teststacc"
}

variable "location" {
  default = "West Europe"
}

variable "environment" {
  default = "global"
}

variable "rg_name" {
  description = "The resource group the storage account will be created in"
  default = "stacc-global-sa-rg"
}

variable "storage_containers" {
  description = "A list of containers to be created"
}

variable "account_kind" {
  default = "StorageV2"
}

variable "enable_https_traffic_only" {
  default = true
}
