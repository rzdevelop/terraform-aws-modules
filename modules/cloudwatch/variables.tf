variable "full_name" {
  description = "Combination of environment, application name and application role"
}

variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}
