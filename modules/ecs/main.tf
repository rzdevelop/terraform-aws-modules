resource "aws_ecs_service" "ecs_service" {
  name                               = var.full_name
  launch_type                        = var.launch_type
  cluster                            = var.cluster_arn
  task_definition                    = var.task_definition_arn
  propagate_tags                     = var.propagate_tags
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  health_check_grace_period_seconds  = var.enable_load_balancer ? var.health_check_grace_period_seconds : null

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [{
      target_group_arn = var.target_group_arn,
      container_name   = var.container_name,
      container_port   = var.container_port
    }] : []

    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  network_configuration {
    security_groups  = local.security_groups
    subnets          = local.subnets
    assign_public_ip = var.assign_public_ip
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  tags = merge(
    var.tags,
    {
      "Resource" = "ECSService"
    },
  )
}
