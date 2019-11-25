variable "name" {
  description = "The prefix of the resources"
  default     = "application_client"
}

variable "reply_urls" {
  description = "List of reply urls"
  type        = list(string)
  default     = [""]
}
