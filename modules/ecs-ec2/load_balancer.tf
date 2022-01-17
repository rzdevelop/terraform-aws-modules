resource "aws_alb_target_group" "default" {
  count = var.enable_load_balancer ? 1 : 0

  name     = local.full_name
  vpc_id   = var.vpc_id
  port     = 80
  protocol = "HTTP"

  health_check {
    path = var.health_check_path
  }

  tags = merge(local.tags, {
    Service  = "EC2"
    Resource = "LoadBalancing"
    Feature  = "TargetGroup"
  })
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  count = var.enable_load_balancer ? 1 : 0

  autoscaling_group_name = data.aws_autoscaling_group.default.id
  alb_target_group_arn   = aws_alb_target_group.default[0].arn
}

resource "aws_lb_listener_rule" "default" {
  count = var.enable_load_balancer ? 1 : 0

  listener_arn = data.aws_lb_listener.https[0].arn
  priority     = var.lb_priority

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.default[0].arn
  }

  condition {
    host_header {
      values = [local.alias]
    }
  }

  tags = merge(local.tags, {
    Service  = "EC2"
    Resource = "LoadBalancing"
    Feature  = "LoadBalancerListenerRule"
  })
}
