module "naming_conventions" {
  source   = "../naming-conventions"
  app_name = var.app_name
  env_name = var.env_name
  purpose  = var.purpose
}

locals {
  full_name  = module.naming_conventions.full_name
  account_id = data.aws_caller_identity.current.account_id
  tags       = module.naming_conventions.default_tags
  alias      = "${module.naming_conventions.full_name}.${var.domain}"
  aliases    = [local.alias]
}

module "cloudwatch" {
  source = "../cloudwatch"

  full_name = local.full_name

  tags = merge(local.tags, {
    Module = "Cloudwatch"
  })
}

resource "aws_ecs_service" "default" {
  name                              = local.full_name
  cluster                           = data.aws_ecs_cluster.default.id
  task_definition                   = var.task_definition_arn
  desired_count                     = var.desired_count
  force_new_deployment              = true
  launch_type                       = enable_capacity_provider_strategy ? null : "EC2"
  propagate_tags                    = "SERVICE"
  wait_for_steady_state             = false
  health_check_grace_period_seconds = 60

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [{
      target_group_arn = aws_alb_target_group.default[0].arn
      container_name   = var.container_name
      container_port   = var.container_port
    }] : []

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.enable_capacity_provider_strategy ? [{
      capacity_provider = var.capacity_provider
      weight            = var.capacity_provider_weight
    }] : []

    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
    }
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  tags = merge(local.tags, {
    "Service" = "ECS"
    "Feature" = "Service"
    },
  )
}

resource "aws_route53_record" "www" {
  for_each = var.enable_load_balancer && var.enable_route53 ? toset(local.aliases) : []
  zone_id  = data.aws_route53_zone.default[0].zone_id
  name     = each.key
  type     = "CNAME"
  ttl      = "5"
  records  = [data.aws_lb.default[0].dns_name]
}
