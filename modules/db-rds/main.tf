module "naming_conventions" {
  source   = "../naming-conventions"
  env_name = var.env_name
  app_name = var.app_name
  purpose  = var.purpose
}

module "security_group" {
  source            = "../security_group"
  full_name         = module.naming_conventions.full_name
  description       = "Security Group for ${module.naming_conventions.full_name}"
  ingress_from_port = 5432
  ingress_to_port   = 5432
  ingress_protocol  = "tcp"
  egress_from_port  = 0
  egress_to_port    = 0
  egress_protocol   = "-1"
  tags = merge(module.naming_conventions.default_tags, {
    Module = "SecurityGroup"
  })
}

module "rds" {
  source     = "../rds"
  sg_id      = module.security_group.id
  identifier = module.naming_conventions.full_name
  name       = var.db_name
  username   = var.db_username
  password   = var.db_password
  tags = merge(module.naming_conventions.default_tags, {
    Module = "RDS"
  })
}
