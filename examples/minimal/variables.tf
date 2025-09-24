variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}

variable "aws_domain_name" {
  type        = string
  default     = "example.com"
  description = "Primary domain name"
}

variable "aws_containers" {
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
  description = "Minimal container configuration"
}
