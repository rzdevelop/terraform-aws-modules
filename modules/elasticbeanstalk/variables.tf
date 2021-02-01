variable "app_name" {
  description = "Combination of environment, application name and application role"
  type        = string
}

variable "full_name" {
  description = "Combination of environment, application name and application role"
  type        = string
}

variable "tags" {
  description = "Map of tags to add to all resources created within this module"
  type        = map(string)
  default     = {}
}

variable "create_application" {
  description = "Boolean to create elasticbeanstalk application"
  type        = bool
  default     = false
}

variable "settings" {
  description = "List of nested settings for the elasticbeanstalk environment"
  type        = list(map(string))
  default     = []
}

variable "solution_stack_name" {
  description = "Application Solution Stack Name"
  type        = string
  default     = "64bit Amazon Linux 2 v3.2.4 running Docker"
}

variable "instance_type" {
  description = "Application Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_key_name" {
  description = "EC2 Key Name"
  type        = string
  default     = ""
}

variable "min_autoscaling" {
  description = "Min Size Autoscaling"
  type        = string
  default     = "1"
}

variable "max_autoscaling" {
  description = "Max Size Autoscaling"
  type        = string
  default     = "2"
}

variable "app_policy_json" {
  type = string
}

variable "attach_other_sec_group" {
  description = "Variable to decide to get security group"
  type        = bool
  default     = true
}

variable "other_sec_group_name" {
  description = "Name of other security group"
  type        = string
}

variable "deployment_policy" {
  description = "Deployment policy"
  type        = string
  default     = "Rolling"
}

variable "log_retention_in_days" {
  description = "Log Retention in Days"
  type        = string
  default     = "7"
}

variable "delete_on_terminate" {
  description = "Delete On terminate Logs"
  type        = string
  default     = "false"
}

variable "ssl_arn" {
  description = "SSL Arn"
  type        = string
}

variable "loadbalancer_type" {
  description = "Load Balancer type"
  type        = string
  default     = "application"
}

variable "healthcheck_path" {
  description = "Health Check Path"
  type        = string
  default     = "/health"
}