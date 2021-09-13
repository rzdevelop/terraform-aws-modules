output "ecs_service_id" {
  description = "ECS Service Id"
  value       = aws_ecs_service.ecs_service.id
}
