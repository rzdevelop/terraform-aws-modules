variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}

variable "full_name" {
  description = "Combination of environment, application name and application role"
  type        = string
}

variable "cluster_arn" {
  description = "ECS Cluster ARN"
  type        = string
}

variable "task_definition_arn" {
  description = "Task Definition ARN"
  type        = string
}

variable "security_groups" {
  description = "Security Groups"
  type        = list(string)
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
}

# Optional
variable "assign_public_ip" {
  description = "Assign public ip"
  type        = bool
  default     = true
}

variable "enable_load_balancer" {
  description = "Enable load balancer"
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Container port when load balancer is enabled"
  type        = number
  default     = -1
}

variable "container_name" {
  description = "Container name when load balancer is enabled"
  type        = string
  default     = ""
}

variable "target_group_arn" {
  description = "Target Group ARN when load balancer is enabled"
  type        = string
  default     = ""
}

variable "health_check_grace_period_seconds" {
  description = "Health Check Grace Period when load balancer is enabled"
  type        = number
  default     = 60
}

variable "launch_type" {
  description = "ECS Service Launch Type"
  type        = string
  default     = "FARGATE"
}

variable "propagate_tags" {
  description = "ECS Service Propagate Tags to Task"
  type        = string
  default     = "SERVICE"
}

variable "desired_count" {
  description = "ECS Service Tasks Desired Count"
  type        = number
  default     = 1
}

variable "deployment_minimum_healthy_percent" {
  description = "ECS Service Deployment Minimun Healthy Percent"
  type        = number
  default     = 50
}

variable "deployment_maximum_percent" {
  description = "ECS Service Deployment Maximun Percent"
  type        = number
  default     = 200
}

variable "enable_network_configuration" {
  description = "ECS Service Enable Network Configuration"
  type        = bool
  default     = true
}
