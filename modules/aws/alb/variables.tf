variable "alb_name" {
  type        = string
  description = "Name of the ALB"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the ALB"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for the ALB"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate for HTTPS"
  default     = ""
}

variable "alb_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the ALB"
  default     = []
}

variable "containers" {
  type = map(object({
    image                            = string
    cpu                              = number
    memory                           = number
    port                             = number
    health_check                     = optional(string)
    health_check_interval            = optional(number)
    health_check_timeout             = optional(number)
    health_check_retries             = optional(number)
    health_check_start_period        = optional(number)
    health_check_healthy_threshold   = optional(number)
    health_check_unhealthy_threshold = optional(number)
    public                           = bool
    domain                           = optional(string)
    protocol                         = string
    port_name                        = optional(string)
    desired_count                    = optional(number)
    environment                      = optional(map(string))
    enable_logs                      = optional(bool, true)
    redirect_to_https                = optional(bool, false)
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
