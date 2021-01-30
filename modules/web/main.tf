module "tags" {
  source   = "../tags"
  env_name = var.env_name
  app_name = var.app_name
  role     = var.role
}

module "s3" {
  source    = "../s3-website"
  full_name = module.tags.full_name
  tags = merge(module.tags.default_tags, {
    Module = "S3"
  })
}

module "cloudfront" {
  source          = "../cloudfront"
  aliases         = var.aliases
  certificate_arn = var.certificate_arn
  domain_name     = module.s3.website_endpoint
  origin_id       = "S3-${module.tags.full_name}-origin"
  tags = merge(module.tags.default_tags, {
    Module = "Cloudfront"
  })
}