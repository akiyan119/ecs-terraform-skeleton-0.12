output "select-type-tg-arn" {
  value = aws_alb_target_group.{{ .Project }}-alb-tg.arn
}

output "dns-name" {
  value = aws_alb.{{ .Project }}-alb.dns_name
}

output "zone-id" {
  value = aws_alb.{{ .Project }}-alb.zone_id
}
