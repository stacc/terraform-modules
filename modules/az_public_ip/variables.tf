variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "count_public_ip" {
  description = "Number of public IPs to be created"
  default     = "2"
}

variable "location" {
  description = "The location of the resources"
  default     = "West Europe"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "sku" {
  description = "The SKU of the public IP"
  default     = "Basic"
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address"
  default     = "Static"
}
