output "ecs_service_id" {
  description = "ECS Service Id"
  value       = aws_ecs_service.ecs_service.id
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.ecs_service.name
}
