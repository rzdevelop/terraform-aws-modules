resource "aws_security_group" "alb" {
  count       = var.enable_load_balancer ? 1 : 0
  name        = "${local.full_name}-alb"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags, {
    Service    = "EC2"
    Feature    = "SecurityGroup"
    Module     = "SecurityGroup"
    ForFeature = "ECSService"
  })
}

resource "aws_lb" "default" {
  count              = var.enable_load_balancer ? 1 : 0
  name               = local.full_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb[0].id]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = merge(local.default_tags, {
    Service    = "EC2"
    Feature    = "LoadBalancer"
    ForFeature = "ECSService"
  })
}

resource "aws_alb_target_group" "default" {
  count       = var.enable_load_balancer ? 1 : 0
  name        = local.full_name
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = merge(local.default_tags, {
    Service    = "EC2"
    Feature    = "LoadBalancer"
    ForFeature = "ECSService"
  })
}

# Redirect to https listener
resource "aws_alb_listener" "http" {
  count             = var.enable_load_balancer ? 1 : 0
  load_balancer_arn = aws_lb.default[0].id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect traffic to target group
resource "aws_alb_listener" "https" {
  count             = var.enable_load_balancer ? 1 : 0
  load_balancer_arn = aws_lb.default[0].id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.alb_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.default[0].id
    type             = "forward"
  }
}
