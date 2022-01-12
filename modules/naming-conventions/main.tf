locals {
  full_name = "${var.env_name}-${var.app_name}-${var.purpose}"
  default_tags = {
    Name        = "${var.env_name}-${var.app_name}-${var.purpose}"
    Environment = var.env_name
    Application = var.app_name
    Purpose     = var.purpose
    Description = "Resource Terraformed for ${local.full_name}"
    Terraform   = "true"
  }
}
