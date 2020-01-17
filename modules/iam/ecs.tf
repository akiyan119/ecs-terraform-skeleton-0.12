resource "aws_iam_role" "{{ .Project }}-task-exec-role" {
  name = "{{ .Project }}-${terraform.workspace}-task-exec-role"
  path = "/system/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "{{ .Project }}-task-exec-policy" {
  name = "{{ .Project }}-task-${terraform.workspace}-exec-policy"
  role = aws_iam_role.{{ .Project }}-task-exec-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents",

        "ssm:GetParameters",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt",

        "s3:*",
        "route53:*", 
        "route53domains:*",

                "cloudwatch:*",
                "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs-autoscale-role" {
  name = "ecs-autoscale-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "application-autoscaling.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF	
}

resource "aws_iam_policy_attachment" "ecs-autoscale-role-attach" {
  name       = "ecs-autoscale-role-attach"
  roles      = [aws_iam_role.ecs-autoscale-role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
