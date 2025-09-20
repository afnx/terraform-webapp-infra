output "name_servers" {
  description = "The Route53 hosted zone nameservers."
  value       = aws_route53_zone.main.name_servers
}