output "ecs_task_role_name" {
  description = "The ECS Task Role name to attach policies as needed"
  value       = aws_iam_role.ecs_task_role.name
}
