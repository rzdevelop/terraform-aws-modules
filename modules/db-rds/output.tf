output "security_group_id" {
  description = "Security Group id"
  value       = module.security_group.id
}

output "security_group_arn" {
  description = "Security Group arn"
  value       = module.security_group.arn
}

output "security_group_vpc_id" {
  description = "Security Group vpc id"
  value       = module.security_group.vpc_id
}

output "security_group_name" {
  description = "Security Group name"
  value       = module.security_group.name
}

output "rds_id" {
  description = "RDS id"
  value       = module.rds.id
}

output "rds_arn" {
  description = "RDS arn"
  value       = module.rds.arn
}

output "rds_address" {
  description = "RDS address"
  value       = module.rds.address
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = module.rds.port
}