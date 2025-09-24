output "alb_arn" {
  value       = aws_lb.main.arn
  description = "ARN of the ALB"
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "DNS name of the ALB"
}

output "alb_zone_id" {
  value       = aws_lb.main.zone_id
  description = "Zone ID of the ALB"
}

output "target_group_arns" {
  value       = { for k, v in aws_lb_target_group.container : k => v.arn }
  description = "Map of target group ARNs for each container"
}

output "alb_target_groups" {
  value = { for k, v in aws_lb_target_group.container : k => {
    target_group_arn = v.arn
    container_name   = k
    container_port   = var.containers[k].port
  } }
  description = "Map of target group details for each container"
}
