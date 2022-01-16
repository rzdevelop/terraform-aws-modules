locals {
  service_name    = local.full_name
  scale_up_name   = "${local.service_name}-up"
  scale_down_name = "${local.service_name}-down"
  metric_alarms = [
    {
      action                      = "down"
      comparison_operator         = "LessThanThreshold"
      threshold                   = 40
      metric_name                 = "CPUUtilization"
      period                      = 300
      statistic                   = "Average"
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    },
    {
      action                      = "up"
      comparison_operator         = "GreaterThanOrEqualToThreshold"
      threshold                   = 70
      metric_name                 = "CPUUtilization"
      period                      = 60
      statistic                   = "Average"
      metric_interval_lower_bound = 1
      scaling_adjustment          = 1
    },
    {
      action                      = "down"
      comparison_operator         = "LessThanThreshold"
      threshold                   = 40
      metric_name                 = "MemoryUtilization"
      period                      = 300
      statistic                   = "Average"
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    },
    {
      action                      = "up"
      comparison_operator         = "GreaterThanOrEqualToThreshold"
      threshold                   = 70
      metric_name                 = "MemoryUtilization"
      period                      = 60
      statistic                   = "Average"
      metric_interval_lower_bound = 1
      scaling_adjustment          = 1
    },
  ]

  iterable_metric_alarms = {
    for k, v in local.metric_alarms : k => v
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity = 2
  min_capacity = 1
  resource_id  = "service/${var.cluster_name}/${local.service_name}"
  role_arn = format(
    "arn:aws:iam::%s:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService",
    data.aws_caller_identity.current.account_id,
  )

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "default" {
  for_each = local.iterable_metric_alarms

  name               = "${local.service_name}-${each.value.metric_name}-${each.value.action}"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = try(each.value.metric_interval_upper_bound, null)
      metric_interval_lower_bound = try(each.value.metric_interval_lower_bound, null)
      scaling_adjustment          = each.value.scaling_adjustment
    }
  }
}

resource "aws_appautoscaling_scheduled_action" "turn_off" {
  count = var.auto_turn_of_and_on.enable ? 1 : 0

  name               = "${local.service_name}-off"
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  schedule           = var.auto_turn_of_and_on.off.schedule

  scalable_target_action {
    min_capacity = var.auto_turn_of_and_on.off.min_capacity
    max_capacity = var.auto_turn_of_and_on.off.max_capacity
  }
}

resource "aws_appautoscaling_scheduled_action" "turn_on" {
  count = var.auto_turn_of_and_on.enable ? 1 : 0

  name               = "${local.service_name}-on"
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  schedule           = var.auto_turn_of_and_on.on.schedule

  scalable_target_action {
    min_capacity = var.auto_turn_of_and_on.on.min_capacity
    max_capacity = var.auto_turn_of_and_on.on.max_capacity
  }
}

resource "aws_cloudwatch_metric_alarm" "default" {
  for_each = local.iterable_metric_alarms

  alarm_description = "Scale ${each.value.action} alarm for ${local.service_name} due to ${each.value.metric_name}"
  namespace         = "AWS/ECS"
  alarm_name        = "${local.service_name}-${each.value.metric_name}-${each.value.action}"
  alarm_actions     = [aws_appautoscaling_policy.default[each.key].arn]

  comparison_operator = each.value.comparison_operator
  threshold           = each.value.threshold
  evaluation_periods  = 1
  metric_name         = each.value.metric_name
  period              = each.value.period
  statistic           = each.value.statistic
  datapoints_to_alarm = 1

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = local.service_name
  }

  tags = merge(local.tags, {
    Service  = "Cloudwatch"
    Resource = "Alarm"
    Feature  = "MetricAlarm"
  })
}
