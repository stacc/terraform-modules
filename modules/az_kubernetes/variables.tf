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

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.13.8"
}

variable "os_disk_size_gb" {
  description = "OS disk size"
  default     = "32"
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
variable "agent_pool_profile_min_count" {
  default = 3
}
variable "agent_pool_profile_max_count" {
  default = 7
}
variable "agent_pool_profile_type" {
  default = "AvailabilitySet"
}
variable "agent_pool_profile_enable_auto_scaling" {
  default = true
}
variable "max_pods" {
  default = 256
}
