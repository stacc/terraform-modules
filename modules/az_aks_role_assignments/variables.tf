variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "aks_rg_id" {}

# variable "db_rg_id" {}

variable "public_ip_rg_id" {}

# variable "sa_rg_id" {}

variable "aks_sp_object_id" {}
