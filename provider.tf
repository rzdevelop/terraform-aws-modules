provider "aws" {
  region = var.aws_region
}

terraform {
  experiments = [variable_validation]
}
