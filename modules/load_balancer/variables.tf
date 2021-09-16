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
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
}

variable "health_check_path" {
  description = "Health Check Path"
  type        = string
  default     = "/"
}

variable "lb_cert_arn" {
  description = "Load Balancer Certificate ARN"
  type        = string
}
