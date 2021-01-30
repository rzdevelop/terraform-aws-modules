locals {
  full_name = "${var.env_name}-${var.app_name}-${var.role}"
  default_tags = {
    Name        = "${var.env_name}-${var.app_name}-${var.role}"
    Environment = var.env_name
    Application = var.app_name
    Role        = var.role
    Description = "Terraformed ${var.env_name}-${var.app_name}-${var.role} for environment ${var.env_name}"
    Terraform   = "true"
  }
}