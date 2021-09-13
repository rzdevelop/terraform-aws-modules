output "id" {
  description = "ECS Service Id"
  value       = aws_ecs_service.ecs_service.id
}

output "name" {
  description = "ECS Service name"
  value       = aws_ecs_service.ecs_service.name
}
