variable "env_name" {
  description = "Name of the Environment (e.g., Dev, QA, Staging, Prod)"
  default     = "dev"
}

variable "app_name" {
  description = "Name of the Application"
}

variable "role" {
  description = "Application role"
  default     = "web"
}

variable "aliases" {
  type        = list(string)
  description = "List of aliases for cloudfront"
  default     = []
}

variable "certificate_arn" {
  type        = string
  description = "SSL Certificate ARN"
}