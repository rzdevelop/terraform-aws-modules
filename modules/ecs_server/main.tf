locals {
  account_id      = data.aws_caller_identity.current.account_id
  cluster_arn     = "arn:aws:ecs:${var.region}:${local.account_id}:cluster/${var.cluster_name}"
  full_name       = module.tags.full_name
  default_tags    = module.tags.default_tags
  use_existing_lb = length(var.load_balancer_arn) > 0 && length(var.load_balancer_name) > 0 && length(var.lb_security_group_id) > 0
}

data "aws_caller_identity" "current" {}

module "tags" {
  source = "../tags"

  env_name = var.env_name
  app_name = var.app_name
  role     = var.role
}

module "cloudwatch" {
  source = "../cloudwatch"

  full_name = local.full_name

  tags = merge(local.default_tags, {
    Module     = "Cloudwatch"
    ForFeature = "ECSService"
  })
}

resource "aws_security_group" "ecs_task" {
  name        = "${local.full_name}-ecs-task"
  description = "ECS Task Security Group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.containers_data

    content {
      protocol         = lookup(ingress.value, "protocol", "tcp")
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      cidr_blocks      = jsondecode(lookup(ingress.value, "cidr", "[\"0.0.0.0/0\"]"))
      ipv6_cidr_blocks = jsondecode(lookup(ingress.value, "ipv6_cidr", "[\"::/0\"]"))
    }
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
    ForFeature = "ECSService"
  })
}

resource "aws_ecs_task_definition" "task_definition" {
  family                   = local.full_name
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = var.network_mode
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = var.requires_compatibilities
  container_definitions    = var.container_definitions

  dynamic "volume" {
    for_each = var.volume != null ? [var.volume] : []

    content {
      name = volume.value.name
      dynamic "docker_volume_configuration" {
        for_each = jsondecode(volume.value.dockerVolumeConfiguration)
        content {
          driverOpts    = docker_volume_configuration.value.driverOpts
          labels        = docker_volume_configuration.value.labels
          driver        = docker_volume_configuration.value.driver
          scope         = docker_volume_configuration.value.scope
          autoprovision = docker_volume_configuration.value.autoprovision
        }
      }
    }
  }

  tags = merge(local.default_tags, {
    Service    = "ECS"
    Feature    = "TaskDefinition"
    ForFeature = "ECSService"
  })
}

module "ecs" {
  source = "../ecs"

  full_name                          = local.full_name
  cluster_arn                        = local.cluster_arn
  task_definition_arn                = aws_ecs_task_definition.task_definition.arn
  security_groups                    = [aws_security_group.ecs_task.id]
  subnets                            = var.subnets
  assign_public_ip                   = var.assign_public_ip
  launch_type                        = var.launch_type
  propagate_tags                     = var.propagate_tags
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  enable_load_balancer              = var.enable_load_balancer
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  target_group_arn                  = var.enable_load_balancer ? aws_lb_target_group.default[0].arn : null
  container_name                    = var.enable_load_balancer ? var.containers_data[0].name : null
  container_port                    = var.enable_load_balancer ? var.containers_data[0].port : null

  tags = merge(local.default_tags, {
    Module = "ECS"
  })
}
