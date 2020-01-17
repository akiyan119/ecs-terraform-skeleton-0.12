resource "aws_ecr_repository" "{{ .Project }}-ecr-repository" {
  name = "{{ .Project }}/${terraform.workspace}"
}

resource "aws_ecr_lifecycle_policy" "{{ .Project }}-task" {
  repository = aws_ecr_repository.{{ .Project }}-ecr-repository.name

  policy = file("${path.module}/policy.json")
}
