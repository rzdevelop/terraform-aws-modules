output "id" {
  description = "RDS id"
  value       = aws_db_instance.default.id
}

output "arn" {
  description = "RDS arn"
  value       = aws_db_instance.default.arn
}

output "address" {
  description = "RDS address"
  value       = aws_db_instance.default.address
}

output "endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.default.endpoint
}

output "port" {
  description = "RDS port"
  value       = aws_db_instance.default.port
}