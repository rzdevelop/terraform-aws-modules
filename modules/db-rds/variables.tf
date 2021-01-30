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

variable "db_username" {
  description = "DB username"
}

variable "db_password" {
  description = "DB password"
}

variable "db_name" {
  description = "DB name"
  type = string
  validation {
    condition     = can(regex("[a-z][a-z0-9_]{1,60}", var.db_name))
    error_message = "The db_name should be fixed. "
  }
}