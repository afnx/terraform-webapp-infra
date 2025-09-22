resource "aws_route53_zone" "main" {
  name = var.domain_name
  tags = var.tags
}

locals {
  dvo_map = { for dvo in var.domain_validation_options : dvo.domain_name => dvo }
}

resource "aws_route53_record" "cert_validation" {
  for_each = toset(concat([var.domain_name], var.subject_alternative_names))

  zone_id = aws_route53_zone.main.id
  name    = local.dvo_map[each.value].resource_record_name
  type    = local.dvo_map[each.value].resource_record_type
  records = [local.dvo_map[each.value].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}
