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
  description = "Minimal container configuration"
}
