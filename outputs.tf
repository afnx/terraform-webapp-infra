output "vpc_id" {
  value       = length(module.aws_vpc) > 0 ? module.aws_vpc[0].vpc_id : null
  description = "The ID of the created VPC"
}

output "public_subnet_ids" {
  value       = length(module.aws_vpc) > 0 ? module.aws_vpc[0].public_subnet_ids : null
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = length(module.aws_vpc) > 0 ? module.aws_vpc[0].private_subnet_ids : null
  description = "List of private subnet IDs"
}

output "alb_dns_name" {
  value       = length(module.aws_alb) > 0 ? module.aws_alb[0].alb_dns_name : null
  description = "DNS name of the Application Load Balancer"
}

output "alb_arn" {
  value       = length(module.aws_alb) > 0 ? module.aws_alb[0].alb_arn : null
  description = "ARN of the Application Load Balancer"
}

output "alb_target_groups" {
  value       = length(module.aws_alb) > 0 ? module.aws_alb[0].alb_target_groups : null
  description = "Map of ALB target group ARNs by container name"
}

output "ecs_cluster_id" {
  value       = length(module.aws_ecs_fargate) > 0 ? module.aws_ecs_fargate[0].ecs_cluster_id : null
  description = "ECS cluster ID"
}

output "ecs_service_names" {
  value       = length(module.aws_ecs_fargate) > 0 ? module.aws_ecs_fargate[0].ecs_service_names : null
  description = "Map of ECS service names by container"
}

output "ecs_task_definition_arns" {
  value       = length(module.aws_ecs_fargate) > 0 ? module.aws_ecs_fargate[0].ecs_task_definition_arns : null
  description = "Map of ECS task definition ARNs by container"
}

output "rds_endpoints" {
  value       = length(module.aws_database) > 0 ? module.aws_database[0].rds_endpoints : null
  description = "Map of RDS instance endpoints by database key"
}

output "rds_arn_map" {
  value       = length(module.aws_database) > 0 ? module.aws_database[0].rds_arn_map : null
  description = "Map of RDS instance ARNs by database key"
}

output "dynamodb_table_names" {
  value       = length(module.aws_database) > 0 ? module.aws_database[0].dynamodb_table_names : null
  description = "Map of DynamoDB table names by database key"
}

output "dynamodb_table_arns" {
  value       = length(module.aws_database) > 0 ? module.aws_database[0].dynamodb_table_arns : null
  description = "Map of DynamoDB table ARNs by database key"
}

output "acm_certificate_arn" {
  value       = length(module.aws_acm) > 0 ? module.aws_acm[0].certificate_arn : null
  description = "ARN of the ACM certificate"
}

output "route53_zone_id" {
  value       = length(module.aws_route53) > 0 ? module.aws_route53[0].zone_id : null
  description = "Route53 hosted zone ID"
}

output "route53_record_names" {
  value       = length(module.aws_route53) > 0 ? module.aws_route53[0].record_names : null
  description = "Map of Route53 record names"
}
