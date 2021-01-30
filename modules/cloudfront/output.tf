output "id" {
  value       = aws_cloudfront_distribution.default.id
  description = "Cloudfront Id"
}

output "arn" {
  value       = aws_cloudfront_distribution.default.arn
  description = "Cloudfront Arn"
}

output "domain_name" {
  value       = aws_cloudfront_distribution.default.domain_name
  description = "Cloudfront Domain Name"
}