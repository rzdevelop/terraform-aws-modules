module "tags" {
  source   = "../tags"
  env_name = var.env_name
  app_name = var.app_name
  role     = var.role
}

module "sns" {
  source    = "../sns"
  full_name = module.tags.full_name
  tags = merge(module.tags.default_tags, {
    Module = "SNS"
  })
}

module "sqs" {
  source                     = "../sqs"
  full_name                  = module.tags.full_name
  visibility_timeout_seconds = var.visibility_timeout_seconds
  dead_letter_enabled        = var.dead_letter_enabled
  dlq_max_receive_count      = var.dlq_max_receive_count
  tags = merge(module.tags.default_tags, {
    Module = "SQS"
  })
}

module "sns-sqs_subscription" {
  source  = "../sns-sqs-subscription"
  sns_arn = module.sns.arn
  sqs_arn = module.sqs.arn
  sqs_url = module.sqs.url
}
