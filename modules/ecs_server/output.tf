output "ecs_service_id" {
  description = "ECS Service Id"
  value       = module.ecs.id
}

output "ecs_service_name" {
  description = "ECS Service name"
  value       = module.ecs.name
}
