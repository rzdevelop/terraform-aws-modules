variable "enable_load_balancer" {
  type        = bool
  default     = true
  description = "Enable Load Balancer Features. (TargetGroup, AutoScalingAttachement, ListenerRule)"
}

variable "enable_route53" {
  type        = bool
  default     = true
  description = "Enable Route53 Features. enable_load_balancer has to be true and domain present"
}

variable "purpose" {
  type        = string
  default     = "api"
  description = "The application's purpose. Api, Worker, etc"
}

variable "domain" {
  type        = string
  default     = ""
  description = "When enable_route53 will set the domain"
}

variable "health_check_path" {
  type        = string
  default     = "/health"
  description = "When enable_load_balancer, the TargetGroup health check path"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "When enable_load_balancer, the VPC ID"
}

variable "hosted_zone_id" {
  type        = string
  default     = ""
  description = "When enable_load_balancer and enable_route53, the Route53 Hosted Zone ID"
}

variable "auto_turn_of_and_on" {
  type = object({
    enable = bool
    on = object({
      schedule     = string
      min_capacity = number
      max_capacity = number
    })
    off = object({
      schedule     = string
      min_capacity = number
      max_capacity = number
    })
  })
  default = {
    enable = false
    off = {
      min_capacity = 0
      max_capacity = 0
      schedule     = "cron(30 7 * * ? *)"
    }
    on = {
      min_capacity = 1
      max_capacity = 2
      schedule     = "cron(0 14 * * ? *)"
    }
  }
  description = "Enable auto turn off and on at night"
}

variable "desired_count" {
  type        = number
  default     = 1
  description = "The ECS Service desired task count"
}

variable "min_capacity" {
  type        = number
  default     = 1
  description = "The ECS AutoScaling Targer min capacity"
}

variable "max_capacity" {
  type        = number
  default     = 2
  description = "The ECS AutoScaling Targer max capacity"
}

variable "app_name" {
  type        = string
  description = "App Name"
}

variable "env_name" {
  type        = string
  description = "Env Name"
}

variable "cluster_name" {
  type        = string
  description = "The ECS Cluster name"
}

variable "container_port" {
  type        = number
  description = "The Container port of the task"
}

variable "container_name" {
  type        = string
  description = "The Container name of the task"
}

variable "task_definition_arn" {
  type        = string
  description = "The Task Definition ARN"
}
