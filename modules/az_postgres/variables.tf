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

