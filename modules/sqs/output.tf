output "arn" {
  description = "SQS Arn"
  value       = aws_sqs_queue.default.arn
}

output "url" {
  description = "SQS Url"
  value       = aws_sqs_queue.default.id
}