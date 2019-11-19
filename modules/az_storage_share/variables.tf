variable "rg_name" {
  default = "stacc-ss-rg"
}

variable "location" {
  default = "West Europe"
}

variable "environment" {
  default = "global"
}

variable "sa_name" {
  description = "A unique name for the storage account"
  default     = "staccfilesa"
}

variable "account_tier" {
  default = "Premium"
}

variable "account_replication_type" {
  default = "LRS"
}

variable "share_name" {
  default = "staccfileshare"
}

variable "share_quota" {
  default = 200
}

variable "kubernetes_cluster" {
}

variable "kubernetes_secret_name" {
  default = "staccfileshare"
}
