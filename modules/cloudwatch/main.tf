resource "aws_cloudwatch_log_group" "log_group" {
  name = var.full_name

  tags = merge(var.tags, {
    Service = "Cloudwatch"
    Feature = "LogGroup"
  })
}
