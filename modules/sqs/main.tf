resource "aws_sqs_queue" "default" {
  name                       = var.full_name
  visibility_timeout_seconds = var.visibility_timeout_seconds

  redrive_policy = var.dead_letter_enabled ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.dlq_max_receive_count
  }) : null

  tags = merge(var.tags, {
    Resource = "SQSQueue"
  })
}

resource "aws_sqs_queue" "dlq" {
  count                      = var.dead_letter_enabled ? 1 : 0
  name                       = "${var.full_name}-dlq"
  visibility_timeout_seconds = var.visibility_timeout_seconds

  tags = merge(var.tags, {
    Resource = "SQSDeadLetterQueue"
  })
}
