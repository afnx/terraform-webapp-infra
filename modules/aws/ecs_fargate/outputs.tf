output "ecs_cluster_id" {
  value       = aws_ecs_cluster.main.id
  description = "The ID of the ECS cluster"
}

output "ecs_task_definition_arns" {
  value       = { for k, v in aws_ecs_task_definition.container : k => v.arn }
  description = "Map of ECS task definition ARNs"
}

output "ecs_service_names" {
  value       = { for k, v in aws_ecs_service.container : k => v.name }
  description = "Map of ECS service names"
}

output "ecs_service_ids" {
  value       = { for k, v in aws_ecs_service.container : k => v.id }
  description = "Map of ECS service IDs"
}

output "ecs_service_desired_counts" {
  value       = { for k, v in aws_ecs_service.container : k => v.desired_count }
  description = "Map of ECS service desired counts"
}

output "ecs_autoscaling_target_arns" {
  value       = { for k, v in aws_appautoscaling_target.container : k => v.arn }
  description = "Map of ECS autoscaling target ARNs"
}
