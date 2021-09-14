locals {
  account_id   = data.aws_caller_identity.current.account_id
  cluster_arn  = "arn:aws:ecs:${var.region}:${local.account_id}:cluster/${var.cluster_name}"
  full_name    = module.tags.full_name
  default_tags = module.tags.default_tags
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

module "ecs-security-group" {
  source = "../security_group"

  full_name   = "${local.full_name}-ecs_task"
  description = "ECS Task Security Group"
  vpc_id      = var.vpc_id

  ingress_from_port   = var.container_port
  ingress_to_port     = var.container_port
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_from_port   = 0
  egress_to_port     = 0
  egress_protocol    = "-1"
  egress_cidr_blocks = ["0.0.0.0/0"]

  tags = merge(local.default_tags, {
    Module     = "SecurityGroup"
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
  security_groups                    = [module.ecs-security-group.id]
  subnets                            = var.subnets
  assign_public_ip                   = var.assign_public_ip
  launch_type                        = var.launch_type
  propagate_tags                     = var.propagate_tags
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  enable_load_balancer               = var.enable_load_balancer
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  target_group_arn                   = var.enable_load_balancer ? aws_alb_target_group.default[0].arn : null
  container_name                     = var.container_name
  container_port                     = var.container_port

  tags = merge(local.default_tags, {
    Module = "ECS"
  })
}
