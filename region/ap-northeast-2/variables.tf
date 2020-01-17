variable "service-name" {
  default = "{{ .Project }}"
}
variable "cpu" {
  default = 256
}
variable "memory" {
  default = 512
}
variable "host-zone-id" {}
variable "domain-name" {}
variable "domain-name-for-cert" {}
variable "name-for-zone" {}
variable "instance-class" {}
variable "rds-name" {}
variable "rds-user" {}
variable "rds-password" {}

