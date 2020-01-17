resource "aws_ecs_cluster" "{{ .Project }}-ecs-cluster" {
  name = "{{ .Project }}-ecs-cluster"

  tags = {
    Name        = "{{ .Project }}-ecs-cluster"
    Environment = terraform.workspace
  }
}

resource "aws_appautoscaling_target" "ecs-target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.{{ .Project }}-ecs-cluster.name}/${var.service-name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = var.ecs-service-autoscaling-arn
  min_capacity       = 2
  max_capacity       = 6
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "scale-up" {
  name               = "scale-up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.{{ .Project }}-ecs-cluster.name}/${var.service-name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 600
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs-target]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "scale-down" {
  name               = "scale-down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.{{ .Project }}-ecs-cluster.name}/${var.service-name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 600
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs-target]
}

# Cloudwatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "cpu-high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.{{ .Project }}-ecs-cluster.name}"
    ServiceName = var.service-name
  }

  alarm_actions = ["${aws_appautoscaling_policy.scale-up.arn}"]
}

# Cloudwatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "cpu-low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.{{ .Project }}-ecs-cluster.name}"
    ServiceName = var.service-name
  }

  alarm_actions = ["${aws_appautoscaling_policy.scale-down.arn}"]
}
