module "alb" {
  count  = var.enable_load_balancer ? local.use_existing_lb ? 0 : 1 : 0
  source = "../load_balancer"

  full_name   = local.full_name
  vpc_id      = var.vpc_id
  subnets     = var.subnets
  lb_cert_arn = var.alb_cert_arn

  tags = merge(local.default_tags, {
    Module = "ALB"
  })
}

data "aws_lb" "existing" {
  count = var.enable_load_balancer ? local.use_existing_lb ? 1 : 0 : 0
  arn   = var.load_balancer_arn
  name  = var.load_balancer_name
}

data "aws_security_group" "existing" {
  count = var.enable_load_balancer ? local.use_existing_lb ? 1 : 0 : 0
  id    = var.lb_security_group_id
}

resource "aws_lb_target_group" "default" {
  count       = var.enable_load_balancer ? 1 : 0
  name        = local.full_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }

  tags = merge(local.default_tags, {
    Service    = "EC2"
    Feature    = "TargetGroup"
    ForFeature = "LoadBalancer"
  })
}

resource "aws_security_group_rule" "ingresses" {
  for_each = { for vm in var.enable_load_balancer ? [var.containers_data[0]] : [] : vm.port => vm }

  type              = "ingress"
  security_group_id = var.enable_load_balancer ? local.use_existing_lb ? data.aws_security_group.existing[0].id : module.alb[0].security_group_id : null

  protocol         = lookup(each.value, "protocol", "tcp")
  from_port        = each.value.port
  to_port          = each.value.port
  cidr_blocks      = jsondecode(lookup(each.value, "cidr", "[\"0.0.0.0/0\"]"))
  ipv6_cidr_blocks = jsondecode(lookup(each.value, "ipv6_cidr", "[\"::/0\"]"))
}

# Redirect traffic to target group
resource "aws_lb_listener" "https" {
  for_each = { for vm in var.enable_load_balancer ? [var.containers_data[0]] : [] : vm.port => vm }

  load_balancer_arn = var.enable_load_balancer ? local.use_existing_lb ? data.aws_lb.existing[0].arn : module.alb[0].arn : null
  port              = each.value.port
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.alb_cert_arn

  default_action {
    target_group_arn = var.enable_load_balancer ? aws_lb_target_group.default[0].arn : null
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "https" {
  for_each = var.enable_load_balancer ? var.lb_listeners_paths: {}
  listener_arn = var.enable_load_balancer ? each.value.https_listener_arn : null
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = var.enable_load_balancer ? aws_lb_target_group.default[0].arn : null
  }

  condition {
    path_pattern {
      values = ["/${each.key}", "/${each.key}/*"]
    }
  }
}

resource "aws_lb_listener_rule" "http" {
  for_each = var.enable_load_balancer ? var.lb_listeners_paths: {}
  listener_arn = var.enable_load_balancer ? each.value.http_listener_arn : null
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = var.enable_load_balancer ? aws_lb_target_group.default[0].arn : null
  }

  condition {
    path_pattern {
      values = ["/${each.key}", "/${each.key}/*"]
    }
  }
}