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

variable "resource_group" {
  description = "The resource group for the Azure Kubernetes Service to be created in"
}

variable "public_ip_rg" {
  description = "The resource group of the public IP to be used"
}

variable "vnet" {
  description = "The virtual network for the Azure Kubernetes Service to be created in"
}
