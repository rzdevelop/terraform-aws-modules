output "id" {
  value       = aws_sns_topic.default.id
  description = "SNS Topic Id"
}

output "arn" {
  value       = aws_sns_topic.default.arn
  description = "SNS Topic Arn"
}