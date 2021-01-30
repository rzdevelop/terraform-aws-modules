output "sqs_arn" {
  description = "SQS Arn"
  value       = module.sqs.arn
}

output "sqs_url" {
  description = "SQS Url"
  value       = module.sqs.id
}

output "sns_id" {
  value       = module.sns.id
  description = "SNS Topic Id"
}

output "sns_arn" {
  value       = module.sns.arn
  description = "SNS Topic Arn"
}