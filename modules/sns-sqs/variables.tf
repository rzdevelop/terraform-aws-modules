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

variable "visibility_timeout_seconds" {
  type = number
}

variable "dead_letter_enabled" {
  type    = bool
  default = false
}

variable "dlq_max_receive_count" {
  type    = number
  default = 1
}
