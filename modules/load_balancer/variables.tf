variable "full_name" {
  description = "Combination of environment, application name and application role"
}

variable "vpc_id" {
  description = "The VPC Id"
}

variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}

variable "load_balancer_type" {
  description = "Load Balancer Type"
  default     = "application"
}

variable "internal" {
  description = "LB Internal option"
  default     = false
}

variable "enable_deletion_protection" {
  description = "LB enable_deletion_protection option"
  default     = false
}

variable "additional_security_groups" {
  description = "Additional Security Groups"
  type        = array(string)
  default     = []
}

variable "subnets" {
  description = "Subnets"
  type        = array(string)
}
