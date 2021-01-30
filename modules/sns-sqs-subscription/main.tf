resource "aws_sns_topic_subscription" "default" {
  protocol  = "sqs"
  topic_arn = var.sns_arn
  endpoint  = var.sqs_arn
}

data "template_file" "policy" {
  template = file("${path.module}/policies/queue_policy.json.tpl")
  vars = {
    sqs_arn = var.sqs_arn
    sns_arn = var.sns_arn
  }
}

resource "aws_sqs_queue_policy" "default" {
  queue_url = var.sqs_url
  policy    = data.template_file.policy.rendered
}