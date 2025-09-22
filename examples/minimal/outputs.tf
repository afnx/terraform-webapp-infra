output "alb_dns_name" {
  value       = module.webapp_infra.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}