variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "location" {
  description = "The location of the resources"
  default     = "West Europe"
}
variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}
variable "acr_name" {
  description = "The name of the Azure Container Registry"
  default     = "stacctest"
}
