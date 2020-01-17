module "vpc" {
  source = "../../modules/vpc"
}

module "sg" {
  source = "../../modules/sg"

  subnet-private-a-cidr-block = module.vpc.subnet-private-a-cidr-block
  subnet-private-c-cidr-block = module.vpc.subnet-private-c-cidr-block
  subnet-public-a-cidr-block  = module.vpc.subnet-public-a-cidr-block
  subnet-public-c-cidr-block  = module.vpc.subnet-public-c-cidr-block
  vpc-id                      = module.vpc.vpc-id
}

module "alb" {
  source = "../../modules/alb"

  vpc-id             = module.vpc.vpc-id
  sg-alb-id          = module.sg.alb-id
  subnet-public-a-id = module.vpc.subnet-public-a-id
  subnet-public-c-id = module.vpc.subnet-public-c-id
  ecs-cluster        = module.ecs.cluster
  certificate-arn    = module.route53.certificate-arn
}

module "ecs" {
  source = "../../modules/ecs"

  service-name                = var.service-name
  cpu                         = var.cpu
  memory                      = var.memory
  ecr-repository-url          = module.ecr.ecr-repository-url
  task-exec-role-arn          = module.iam.task-exec-role.arn
  target-group-arn            = module.alb.select-type-tg-arn
  security-groups             = module.sg.ecs-id
  subnet-public-a-id          = module.vpc.subnet-public-a-id
  subnet-public-c-id          = module.vpc.subnet-public-c-id
  ecs-service-autoscaling-arn = module.iam.ecs-service-autoscaling-arn
}

module "ecr" {
  source = "../../modules/ecr"
}

module "iam" {
  source = "../../modules/iam"
}

module "rds" {
  source                = "../../modules/rds"
  vpc-security-group-id = module.sg.rds-id
  rds-subnet-group-name = module.vpc.subnet-group-rds-name
  instance-class        = var.instance-class
  rds-name              = var.rds-name
  rds-user              = var.rds-user
  rds-password          = var.rds-password
}

module "route53" {
  source = "../../modules/route53"

  host-zone-id         = var.host-zone-id
  domain-name          = var.domain-name
  domain-name-for-cert = var.domain-name-for-cert
  name-for-zone        = var.name-for-zone
  target-zone-id       = module.alb.zone-id
  target-zone-name     = module.alb.dns-name
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
}
