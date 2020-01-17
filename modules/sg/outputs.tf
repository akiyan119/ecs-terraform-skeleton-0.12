output "alb-id" {
  value = aws_security_group.{{ .Project }}-alb.id
}

output "ecs-id" {
  value = aws_security_group.{{ .Project }}-ecs.id
}

output "rds-id" {
  value = aws_security_group.{{ .Project }}-rds.id
}
