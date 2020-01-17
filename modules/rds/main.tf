#resource "random_string" "password" {
#  length           = 16
#}

resource "aws_db_instance" "{{ .Project }}-rds" {
  identifier              = "tf-dbinstance"
  allocated_storage       = 51
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = var.instance-class
  storage_type            = "gp2"
  name                    = var.rds-name
  username                = var.rds-user
  password                = var.rds-password
  backup_retention_period = 1
  vpc_security_group_ids  = [var.vpc-security-group-id]
  db_subnet_group_name    = var.rds-subnet-group-name
  skip_final_snapshot     = true
}

