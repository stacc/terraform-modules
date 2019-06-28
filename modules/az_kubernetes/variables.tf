variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "location" {
  description = "The location of the resources"
  default     = "West Europe"
}

variable "node_count" {
  description = "Number of nodes"
  default     = "2"
}

variable "node_type" {
  description = "The type of nodes"
  default     = "Standard_DS3_v2"
}

variable "resource_group" {
  description = "The resource group for the Azure Kubernetes Service to be created in"
}

variable "public_ip_rg" {
  description = "The resource group of the public IP to be used"
}

variable "vnet" {
  description = "The virtual network for the Azure Kubernetes Service to be created in"
}
