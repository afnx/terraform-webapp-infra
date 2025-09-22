output "alb_dns_name" {
  value       = module.webapp_infra.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "rds_endpoint" {
  value       = module.webapp_infra.rds_endpoint
  description = "RDS database endpoint"
}

output "dynamodb_table_names" {
  value       = module.webapp_infra.dynamodb_table_names
  description = "List of DynamoDB table names"
}

output "ecs_service_names" {
  value       = module.webapp_infra.ecs_service_names
  description = "List of ECS service names"
}
