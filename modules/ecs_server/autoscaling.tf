locals {
  service_name    = module.ecs.name
  scale_up_name   = "${local.service_name}-up"
  scale_down_name = "${local.service_name}-down"
}

resource "aws_appautoscaling_target" "ecs_target" {
  count        = var.enable_autoscaling ? 1 : 0
  max_capacity = var.max_capacity
  min_capacity = var.min_capacity
  resource_id  = "service/${var.cluster_name}/${module.ecs.name}"
  role_arn = format(
    "arn:aws:iam::%s:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService",
    data.aws_caller_identity.current.account_id,
  )

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

###################################
############### DOWN ##############
###################################
resource "aws_appautoscaling_policy" "policy_scale_down" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = local.scale_down_name
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_scale_down" {
  count             = var.enable_autoscaling ? 1 : 0
  alarm_description = "Scale down alarm for ${module.ecs.name}"
  namespace         = "AWS/ECS"
  alarm_name        = local.scale_down_name
  alarm_actions     = [aws_appautoscaling_policy.policy_scale_down[0].arn]

  comparison_operator = "LessThanThreshold"
  threshold           = 40
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  period              = 60
  statistic           = "Average"
  datapoints_to_alarm = 1

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = module.ecs.name
  }

  tags = merge(local.default_tags, {
    Service    = "Cloudwatch"
    Feature    = "MetricAlarm"
    ForFeature = "ECSService"
  })
}

###################################
################ UP ###############
###################################

resource "aws_appautoscaling_policy" "policy_scale_up" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = local.scale_up_name
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 1
      scaling_adjustment          = 1
    }
  }
}
resource "aws_cloudwatch_metric_alarm" "alarm_scale_up" {
  count             = var.enable_autoscaling ? 1 : 0
  alarm_description = "Scale up alarm for ${module.ecs.name}"
  namespace         = "AWS/ECS"
  alarm_name        = local.scale_up_name
  alarm_actions     = [aws_appautoscaling_policy.policy_scale_up[0].arn]

  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 70
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  period              = 60
  statistic           = "Average"
  datapoints_to_alarm = 1

  dimensions = {
    ClusterName = var.cluster_name
    ServiceName = module.ecs.name
  }

  tags = merge(local.default_tags, {
    Service    = "Cloudwatch"
    Feature    = "MetricAlarm"
    ForFeature = "ECSService"
  })
}

# resource "aws_appautoscaling_target" "autoscaling_target" {
#   count              = var.enable_autoscaling ? 1 : 0
#   max_capacity       = var.max_capacity
#   min_capacity       = var.min_capacity
#   resource_id        = "service/${var.cluster_name}/${module.ecs.name}"
#   scalable_dimension = "ecs:service:DesiredCount"
#   service_namespace  = "ecs"
# }

# resource "aws_appautoscaling_policy" "ecs_policy_memory" {
#   count              = var.enable_autoscaling ? 1 : 0
#   name               = "${local.full_name}-memory-autoscaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.autoscaling_target[0].resource_id
#   scalable_dimension = aws_appautoscaling_target.autoscaling_target[0].scalable_dimension
#   service_namespace  = aws_appautoscaling_target.autoscaling_target[0].service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageMemoryUtilization"
#     }

#     target_value       = var.memory_autoscaling_target_value
#     scale_in_cooldown  = 300
#     scale_out_cooldown = 300
#   }
# }

# resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
#   count              = var.enable_autoscaling ? 1 : 0
#   name               = "${local.full_name}-cpu-autoscaling"
#   policy_type        = "TargetTrackingScaling"
#   resource_id        = aws_appautoscaling_target.autoscaling_target[0].resource_id
#   scalable_dimension = aws_appautoscaling_target.autoscaling_target[0].scalable_dimension
#   service_namespace  = aws_appautoscaling_target.autoscaling_target[0].service_namespace

#   target_tracking_scaling_policy_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ECSServiceAverageCPUUtilization"
#     }

#     target_value       = var.cpu_autoscaling_target_value
#     scale_in_cooldown  = 300
#     scale_out_cooldown = 300
#   }
# }
