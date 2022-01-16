
data "aws_ecs_cluster" "default" {
  cluster_name = var.cluster_name
}

data "aws_autoscaling_group" "default" {
  name = var.cluster_name
}

data "aws_lb" "default" {
  count = var.enable_load_balancer ? 1 : 0

  name = var.cluster_name
}

data "aws_lb_listener" "https" {
  count = var.enable_load_balancer ? 1 : 0

  load_balancer_arn = data.aws_lb.default[0].arn
  port              = 443
}

data "aws_acm_certificate" "default" {
  count = var.enable_load_balancer && var.enable_route53 ? 1 : 0

  domain = "*.${var.domain}"
}

data "aws_route53_zone" "default" {
  count = var.enable_load_balancer && var.enable_route53 ? 1 : 0

  zone_id = var.hosted_zone_id
}

data "aws_caller_identity" "current" {}
