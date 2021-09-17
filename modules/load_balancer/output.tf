output "id" {
  value       = aws_lb.default.id
  description = "LB Id"
}

output "arn" {
  value       = aws_lb.default.arn
  description = "LB Arn"
}

output "dns_name" {
  value       = aws_lb.default.dns_name
  description = "LB DNS Name"
}

output "security_group_id" {
  value       = aws_security_group.lb.id
  description = "LB Id"
}

output "security_group_arn" {
  value       = aws_security_group.lb.arn
  description = "LB Arn"
}

output "target_group_arn" {
  value = aws_lb_target_group.default.arn
}

output "target_group_id" {
  value = aws_lb_target_group.default.id
}

output "target_group_name" {
  value = aws_lb_target_group.default.name
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https.arn
}