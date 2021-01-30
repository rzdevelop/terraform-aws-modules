output "full_name" {
  description = "Combination of environment, application name and application role"
  value       = local.full_name
}

output "default_tags" {
  description = "Default tags"
  value       = local.default_tags
}