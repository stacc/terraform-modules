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
