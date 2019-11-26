variable "name" {
  description = "The prefix of the resources"
  default     = "stacc"
}

variable "environment" {
  description = "The environment of the resources"
  default     = "test-1"
}

variable "group_object_id" {
  description = "Object ID of AD group to add pipeline service principal to"
}
