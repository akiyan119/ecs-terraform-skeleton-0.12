output "rds-password" {
  value = aws_db_instance.{{ .Project }}-rds.password
}
