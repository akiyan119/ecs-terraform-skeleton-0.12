data "aws_route53_zone" "zone" {
  name         = var.name-for-zone
  private_zone = false
}

resource "aws_route53_record" "A" {
  zone_id = var.host-zone-id
  name    = var.domain-name
  type    = "A"

  alias {
    name                   = var.target-zone-name
    zone_id                = var.target-zone-id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain-name-for-cert
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [aws_acm_certificate.cert.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
