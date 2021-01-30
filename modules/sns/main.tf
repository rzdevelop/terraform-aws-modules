resource "aws_sns_topic" "default" {
  name = var.full_name

  tags = merge(var.tags, {
    Resource = "SNSTopic"
  })
}