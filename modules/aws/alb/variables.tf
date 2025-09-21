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
  description = "Map of containers to deploy"
  type = map(object({
    image        = string
    cpu          = number
    memory       = number
    port         = number
    health_check = string
    public       = bool
    domain       = string
    protocol     = string
  }))
}
