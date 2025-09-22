variable "vpc_id" {
  type        = string
  description = "VPC ID for ECS tasks"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks"
}

variable "alb_target_groups" {
  type        = list(string)
  description = "List of ALB target group ARNs to attach to the ECS service"
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

variable "containers" {
  type = map(object({
    image         = string
    cpu           = number
    memory        = number
    port          = number
    health_check  = optional(string)
    public        = bool
    domain        = optional(string)
    protocol      = string
    desired_count = optional(number)
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
