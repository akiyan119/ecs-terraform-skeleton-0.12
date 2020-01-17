output "task-exec-role" {
  value = aws_iam_role.{{ .Project }}-task-exec-role
}

output "ecs-service-autoscaling-arn" {
  value = aws_iam_role.ecs-autoscale-role.arn
}
