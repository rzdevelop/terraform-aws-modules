module "alb" {
  count  = var.enable_load_balancer ? local.prevent_lb_creation ? 0 : 1 : 0
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
  count = var.enable_load_balancer ? local.prevent_lb_creation ? 1 : 0 : 0
  arn   = var.load_balancer_arn
  name  = var.load_balancer_name
}

data "aws_security_group" "existing" {
  count = var.enable_load_balancer ? local.prevent_lb_creation ? 1 : 0 : 0
  id    = var.lb_security_group_id
}

data "aws_lb_target_group" "existing" {
  count = var.enable_load_balancer ? local.prevent_lb_creation ? 1 : 0 : 0
  arn   = var.target_group_arn
}

resource "aws_security_group_rule" "ingresses" {
  for_each = { for vm in var.enable_load_balancer ? var.containers_data : [] : vm.port => vm }

  type              = "ingress"
  security_group_id = var.enable_load_balancer ? local.prevent_lb_creation ? data.aws_security_group.existing[0].id : module.alb[0].security_group_id : null

  protocol         = lookup(each.value, "protocol", "tcp")
  from_port        = each.value.port
  to_port          = each.value.port
  cidr_blocks      = jsondecode(lookup(each.value, "cidr", "[\"0.0.0.0/0\"]"))
  ipv6_cidr_blocks = jsondecode(lookup(each.value, "ipv6_cidr", "[\"::/0\"]"))
}
