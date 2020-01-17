resource "aws_cloudwatch_log_group" "log_group" {
  name = "${terraform.workspace}/{{ .Project }}"

  tags = {
    Environment = terraform.workspace
  }
}
