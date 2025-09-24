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

resource "aws_route53_record" "alb_alias" {
  for_each = {
    for c in var.containers : c.domain => c
    if c.public && lookup(c, "domain", null) != null
  }

  zone_id = aws_route53_zone.main.id
  name    = each.value.domain
  type    = "A"
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
