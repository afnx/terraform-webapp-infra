output "name_servers" {
  description = "The Route53 hosted zone nameservers."
  value       = aws_route53_zone.main.name_servers
}

output "zone_id" {
  description = "The Route53 hosted zone ID."
  value       = aws_route53_zone.main.zone_id
}

output "record_names" {
  description = "Map of Route53 record names"
  value       = { for record in aws_route53_record.cert_validation : record.name => record.name }
}
