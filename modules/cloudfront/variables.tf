variable "aliases" {
  type        = list(string)
  description = "List of aliases"
  default     = []
}

variable "certificate_arn" {
  type        = string
  description = "SSL Certificate ARN"
}

variable "domain_name" {
  type        = string
  description = "Domain Name"
}

variable "origin_id" {
  type        = string
  description = "Origin Id"
}

variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}

variable "origin_access_identity" {
  description = "Cloudfront Origin Access Identity"
  type        = string
}