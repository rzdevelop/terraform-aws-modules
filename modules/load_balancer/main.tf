
resource "aws_security_group" "lb" {
  name        = "${var.full_name}-lb-sec-group"
  description = "LB Security Group"
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

  tags = merge(var.tags, {
    Name       = "${var.full_name}-lb-sec-group"
    Module     = "SecurityGroup"
    Service    = "EC2"
    Feature    = "SecurityGroup"
    ForFeature = "LoadBalancer"
  })
}

resource "aws_lb_target_group" "default" {
  name        = var.full_name
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

  tags = merge(var.tags, {
    Service    = "EC2"
    Feature    = "TargetGroup"
    ForFeature = "LoadBalancer"
  })
}

# Redirect to https listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.default.id
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
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.default.id
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.lb_cert_arn

  default_action {
    target_group_arn = aws_lb_target_group.default.id
    type             = "forward"
  }
}


resource "aws_lb" "default" {
  name               = var.full_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = concat([aws_security_group.lb.id], var.additional_security_groups)
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Service = "EC2"
    Feature = "LoadBalancer"
  })
}
