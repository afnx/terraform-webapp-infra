output "vpc_id" {
  value       = module.aws_vpc[0].vpc_id
  description = "The ID of the created VPC"
}

output "public_subnet_ids" {
  value       = module.aws_vpc[0].public_subnet_ids
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.aws_vpc[0].private_subnet_ids
  description = "List of private subnet IDs"
}

output "alb_dns_name" {
  value       = module.aws_alb[0].alb_dns_name
  description = "DNS name of the Application Load Balancer"
}

output "alb_arn" {
  value       = module.aws_alb[0].alb_arn
  description = "ARN of the Application Load Balancer"
}

output "alb_target_groups" {
  value       = module.aws_alb[0].alb_target_groups
  description = "Map of ALB target group ARNs by container name"
}

output "ecs_cluster_id" {
  value       = module.aws_ecs_fargate[0].ecs_cluster_id
  description = "ECS cluster ID"
}

output "ecs_service_names" {
  value       = module.aws_ecs_fargate[0].ecs_service_names
  description = "Map of ECS service names by container"
}

output "ecs_task_definition_arns" {
  value       = module.aws_ecs_fargate[0].ecs_task_definition_arns
  description = "Map of ECS task definition ARNs by container"
}

output "rds_endpoints" {
  value       = module.aws_database[0].rds_endpoints
  description = "Map of RDS instance endpoints by database key"
}

output "rds_arn_map" {
  value       = module.aws_database[0].rds_arn_map
  description = "Map of RDS instance ARNs by database key"
}

output "dynamodb_table_names" {
  value       = module.aws_database[0].dynamodb_table_names
  description = "Map of DynamoDB table names by database key"
}

output "dynamodb_table_arns" {
  value       = module.aws_database[0].dynamodb_table_arns
  description = "Map of DynamoDB table ARNs by database key"
}

output "acm_certificate_arn" {
  value       = module.aws_acm[0].certificate_arn
  description = "ARN of the ACM certificate"
}

output "route53_zone_id" {
  value       = module.aws_route53[0].zone_id
  description = "Route53 hosted zone ID"
}

output "route53_record_names" {
  value       = module.aws_route53[0].record_names
  description = "Map of Route53 record names"
}
