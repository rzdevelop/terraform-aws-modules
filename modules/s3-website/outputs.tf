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

output "cloudfront_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.OAI.cloudfront_access_identity_path
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.defauly.bucket_regional_domain_name
}