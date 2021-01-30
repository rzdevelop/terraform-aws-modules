output "website_endpoint" {
  value       = aws_s3_bucket.default.website_endpoint
  description = "Website Endpoint"
}

output "id" {
  value       = aws_s3_bucket.default.id
  description = "Bucket Id"
}

output "arn" {
  value       = aws_s3_bucket.default.arn
  description = "Bucket arn"
}