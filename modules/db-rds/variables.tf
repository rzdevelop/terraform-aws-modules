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