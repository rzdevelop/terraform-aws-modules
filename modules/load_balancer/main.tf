
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
    Module     = "SecurityGroup"
    Service    = "EC2"
    Feature    = "SecurityGroup"
    ForFeature = "LoadBalancer"
  })
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
