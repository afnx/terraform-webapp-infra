output "alb_arn" {
  value       = aws_lb.main.arn
  description = "ARN of the ALB"
}

output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "DNS name of the ALB"
}

output "target_group_arns" {
  value       = { for k, v in aws_lb_target_group.container : k => v.arn }
  description = "Map of target group ARNs for each container"
}
