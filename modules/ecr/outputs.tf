output "ecr-repository-url" {
  value = aws_ecr_repository.{{ .Project }}-ecr-repository.repository_url
}
