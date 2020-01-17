variable "vpc-id" {}

variable "sg-alb-id" {}

variable "ecs-cluster" {}
variable "subnet-public-a-id" {}
variable "subnet-public-c-id" {}
variable "certificate-arn" {}

variable "load_balancer_rule" {
  type = map(string)
  default = {
    "task.health_check_interval" = 30
    "task.health_check_timeout"  = 29
    "task.healthy_threshold"     = 3
    "task.unhealthy_threshold"   = 2
    "task.min_capacity"          = 1
    "task.max_capacity"          = 5
    "task.cpu_high_statistic"    = "Average"
    "task.cpu_low_statistic"     = "Average"
    "task.cpu_high_threshold"    = 60
    "task.cpu_low_threshold"     = 30
    "task.scale_up_cooldown"     = 600
    "task.scale_down_cooldown"   = 600
    "task.deregistration_delay"  = 60
  }
}
