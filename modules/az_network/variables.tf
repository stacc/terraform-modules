variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "resource_group" {
  description = "The resource group for the network resources to be created in"
}

variable "address_space" {
  description = "Address space of vnet"
  default     = ["10.1.0.0/16"]
}
