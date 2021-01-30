output "id" {
  description = "Security Group id"
  value       = aws_security_group.default.id
}

output "arn" {
  description = "Security Group arn"
  value       = aws_security_group.default.arn
}

output "vpc_id" {
  description = "Security Group vpc id"
  value       = aws_security_group.default.vpc_id
}

output "name" {
  description = "Security Group name"
  value       = aws_security_group.default.name
}