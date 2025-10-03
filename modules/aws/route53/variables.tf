variable "domain_name" {
  type        = string
  description = "The domain name for which the Route53 hosted zone will be created."
}

variable "domain_validation_options" {
  type        = list(any)
  description = "List of domain validation options for Route53 records, typically from ACM certificate validation."
}

variable "certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate to validate using Route53 DNS records."
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "A list of additional domain names for the ACM certificate."
}

variable "alb_dns_name" {
  type        = string
  description = "DNS name of the ALB"
}

variable "alb_zone_id" {
  type        = string
  description = "Zone ID of the ALB"
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
    enable_logs                      = optional(bool, false)
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
  description = "List of container definitions"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}
