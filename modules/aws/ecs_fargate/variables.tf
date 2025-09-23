variable "region" {
  type        = string
  description = "AWS region to deploy resources in"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for ECS tasks"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks"
}

variable "alb_target_groups" {
  type = map(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  description = "Map of ALB target group info for each container"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "ecs_task_execution_role_name" {
  type        = string
  description = "Name of the ECS task execution role"
}

variable "ecs_security_group_name" {
  type        = string
  description = "Name for the ECS tasks security group"
}

variable "ecs_security_group_description" {
  type        = string
  description = "Description for the ECS tasks security group"
}

variable "ecs_security_group_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks for egress rules in the ECS tasks security group"
}

variable "ecs_task_definition_family_name" {
  type        = string
  description = "Family name for the ECS task definition"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service"
}

variable "service_connect_namespace" {
  type        = string
  description = "Cloud Map namespace for ECS Service Connect"
}

variable "log_group_name" {
  type        = string
  description = "Name of the CloudWatch log group for ECS tasks"
}

variable "containers" {
  type = map(object({
    image                     = string
    cpu                       = number
    memory                    = number
    port                      = number
    health_check              = optional(string)
    health_check_interval     = optional(number)
    health_check_timeout      = optional(number)
    health_check_retries      = optional(number)
    health_check_start_period = optional(number)
    public                    = bool
    domain                    = optional(string)
    protocol                  = string
    port_name                 = optional(string)
    desired_count             = optional(number)
    environment               = optional(map(string))
    enable_logs               = optional(bool, true)
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })))
    autoscaling = optional(object({
      min_capacity       = number
      max_capacity       = number
      target_cpu         = number
      scale_in_cooldown  = number
      scale_out_cooldown = number
    }))
  }))
  description = "Map of containers to deploy"
}
