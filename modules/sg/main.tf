# Default
resource "aws_default_security_group" "security-group-default" {
  vpc_id = var.vpc-id

  tags = {
    Name        = "{{ .Project }}-default-sg"
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "{{ .Project }}-alb" {
  vpc_id = var.vpc-id
  name   = "{{ .Project }}-alb"

  tags = {
    Name        = "{{ .Project }}-alb"
    Environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "security-group-alb-in-rule-alb-https" {
  security_group_id = aws_security_group.{{ .Project }}-alb.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "security-group-alb-out-rule-alb" {
  security_group_id = aws_security_group.{{ .Project }}-alb.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group" "{{ .Project }}-ecs" {
  vpc_id = var.vpc-id
  name   = "{{ .Project }}_ecs"

  tags = {
    Name        = "{{ .Project }}-ecs"
    Environment = terraform.workspace
  }
}

resource "aws_security_group_rule" "security-group-ecs-in-rule-alb" {
  security_group_id        = aws_security_group.{{ .Project }}-ecs.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.{{ .Project }}-alb.id
}

resource "aws_security_group_rule" "security-group-ecs-out-rule-alb" {
  security_group_id = aws_security_group.{{ .Project }}-ecs.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# RDS
resource "aws_security_group" "{{ .Project }}-rds" {
  vpc_id = var.vpc-id
  name   = "{{ .Project }}-rds"
}

resource "aws_security_group_rule" "{{ .Project }}-rds-rule-ingress" {
  security_group_id = aws_security_group.{{ .Project }}-rds.id
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  description       = "Allow rds inbound traffic from ECS"
  #cidr_blocks       = ["0.0.0.0/0"]
  source_security_group_id = aws_security_group.{{ .Project }}-ecs.id
}

resource "aws_security_group_rule" "{{ .Project }}-rds-rule-egress" {
  security_group_id = aws_security_group.{{ .Project }}-rds.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow rds egress traffic to all"
}
