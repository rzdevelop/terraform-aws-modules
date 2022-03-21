variable "env_name" {
  description = "Name of the Environment (e.g., Dev, QA, Staging, Prod)"
  default     = "dev"
}

variable "app_name" {
  description = "Name of the Application"
}

variable "purpose" {
  description = "Application purpose"
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
  type        = string
}

variable "engine_version" {
  default     = "12.7"
  description = "Engine Version"
  type        = string
}