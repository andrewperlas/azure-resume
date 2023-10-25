variable "rg_name" {
  description = "Resource Group name"
  type        = string
}

variable "storage_name" {
  description = "Storage Account name"
  type        = string
}

variable "subscription" {
  description = "Subscription ID"
  type        = string
}

variable "location" {
  description = "Resource location"
  type        = string
  default     = "West US 2"
}

variable "container_name" {
  description = "Storage account container name"
  type        = string
}

variable "cdnprofile_name" {
  description = "CDN Profile name"
  type        = string
}

variable "cdnendpoint_name" {
  description = "CDN Endpoint name"
  type        = string
}

variable "cdncustomdomain_name" {
  description = "CDN Custom Domain resource name"
  type        = string
}

variable "cdncustomdomain_hostname" {
  description = "CDN Custom Domain URL"
  type        = string
}

variable "environment_tag" {
  description = "Environment tag"
  type        = string
}