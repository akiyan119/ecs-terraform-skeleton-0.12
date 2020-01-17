resource "aws_alb" "{{ .Project }}-alb" {
  name                       = "{{ .Project }}-alb"
  security_groups            = [var.sg-alb-id]
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = false

  subnets = [
    var.subnet-public-a-id,
    var.subnet-public-c-id,
  ]

  tags = {
    Environment = terraform.workspace
  }
}

resource "aws_alb_target_group" "{{ .Project }}-alb-tg" {

  name        = "{{ .Project }}-alb-tg"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = var.vpc-id
  target_type = "ip"

  health_check {
    interval            = 60
    path                = "/"
    port                = 443
    protocol            = "HTTPS"
    timeout             = 20
    unhealthy_threshold = 4
    matcher             = 200
  }

  tags = {
    Name        = "alb-target-alb-tg"
    Environment = terraform.workspace
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.{{ .Project }}-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = var.certificate-arn

  default_action {
    target_group_arn = aws_alb_target_group.{{ .Project }}-alb-tg.arn
    type             = "forward"
  }
}
