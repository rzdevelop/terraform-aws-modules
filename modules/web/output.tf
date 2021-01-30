output "cloudfront_id" {
  value       = module.cloudfront.id
  description = "Cloudfront Id"
}

output "cloudfront_arn" {
  value       = module.cloudfront.arn
  description = "Cloudfront Arn"
}

output "cloudfront_domain_name" {
  value       = module.cloudfront.domain_name
  description = "Cloudfront Domain Name"
}

output "s3_website_endpoint" {
  value       = module.s3.website_endpoint
  description = "Website Endpoint"
}

output "s3_id" {
  value       = module.s3.id
  description = "Bucket Id"
}

output "s3_arn" {
  value       = module.s3.arn
  description = "Bucket arn"
}