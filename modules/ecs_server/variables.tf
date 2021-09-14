variable "env_name" {
  description = "Name of the Environment (e.g., Dev, QA, Staging, Prod)"
  default     = "dev"
}

variable "app_name" {
  description = "Name of the Application"
}

variable "role" {
  description = "Application role"
  default     = "api"
}

variable "cluster_name" {
  description = "ECS Cluster ARN"
  type        = string
}
variable "vpc_id" {
  description = "VPC Id"
  type        = string
}

variable "container_definitions" {
  description = "Container definitions, JSON string-like"
  type        = string
}

variable "subnets" {
  description = "Subnets"
  type        = list(string)
}

# Optional
variable "region" {
  description = "AWS Cluster Region"
  type        = string
  default     = "us-east-1"
}

variable "container_port" {
  description = "Container port when load balancer is enabled"
  type        = number
  default     = -1
}

variable "task_role_actions" {
  description = "Task Role Actions"
  type        = list(string)
  default     = []
}

variable "task_role_resources" {
  description = "Task Role Resources"
  type        = list(string)
  default     = []
}

variable "enable_task_role_additional_policy" {
  description = "Enable Additional policy arn"
  type        = bool
  default     = false
}

variable "additional_policy_arn" {
  description = "Additional policy arn"
  type        = string
  default     = ""
}

variable "network_mode" {
  description = "Network Mode"
  type        = string
  default     = "awsvpc"
}

variable "cpu" {
  description = "CPU"
  type        = string
  default     = "512"
}

variable "memory" {
  description = "Memory"
  type        = string
  default     = "1024"
}

variable "requires_compatibilities" {
  description = "Requires compatibilities"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "enable_autoscaling" {
  description = "Enable autoscaling"
  type        = bool
  default     = false
}

variable "max_capacity" {
  description = "Autoscaling Max Capacity"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Autoscaling Min Capacity"
  type        = number
  default     = 1
}

variable "cpu_autoscaling_target_value" {
  description = "CPU AutoScaling Target Value"
  type        = number
  default     = 80
}

variable "memory_autoscaling_target_value" {
  description = "Memory AutoScaling Target Value"
  type        = number
  default     = 80
}

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

variable "containers_data" {
  description = "List of maps of the containers info. [{ name = 'Container name', port = '80', cidr = '[\"0.0.0.0/0\"]' }]"
  type        = list(map(string))
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

variable "alb_cert_arn" {
  description = "When load balancer is enabled, the HTTPS certificate arn"
  type        = string
  default     = ""
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
