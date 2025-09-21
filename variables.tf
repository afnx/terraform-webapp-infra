variable "deploy_aws" {
  type        = bool
  description = "Whether to deploy AWS resources."
  default     = true
}

variable "aws_region" {
  description = "Region to deploy AWS resources."
  type        = string
  default     = "us-west-2"
}

variable "aws_tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "production"
    Owner       = "your-team"
    Project     = "webapp"
  }
}

variable "aws_domain_name" {
  type        = string
  description = "The primary domain name for the ACM certificate."
}

variable "aws_subject_alternative_names" {
  type        = list(string)
  description = "A list of additional domain names for the ACM certificate. Domain names could be subdomains."
}

variable "aws_vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "aws_public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "aws_private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDRs"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "aws_alb_name" {
  type        = string
  description = "Name of the ALB"
  default     = "webapp-alb"
}

variable "aws_alb_security_group_name" {
  type        = string
  description = "Name for the ALB security group"
  default     = "webapp-alb-sg"
}

variable "aws_alb_security_group_description" {
  type        = string
  description = "Description for the ALB security group"
  default     = "Security group for the Application Load Balancer"
}

variable "aws_alb_ingress_cidr_blocks_http" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access ALB on HTTP (port 80)"
  default     = ["0.0.0.0/0"]
}

variable "aws_alb_ingress_cidr_blocks_https" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access ALB on HTTPS (port 443)"
  default     = ["0.0.0.0/0"]
}

variable "aws_alb_egress_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed for ALB egress"
  default     = ["0.0.0.0/0"]
}

variable "aws_containers" {
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
  default = {
    frontend = {
      image        = "my-frontend:latest"
      cpu          = 256
      memory       = 512
      port         = 80
      health_check = "/health"
      public       = true
      domain       = "example.com"
      protocol     = "HTTPS"
    }
    backend = {
      image        = "my-backend:latest"
      cpu          = 256
      memory       = 512
      port         = 8080
      health_check = "/health"
      public       = true
      domain       = "api.example.com"
      protocol     = "HTTPS"
    }
    db = {
      image        = "my-db:latest"
      cpu          = 256
      memory       = 512
      port         = 5432
      health_check = ""
      public       = false
      domain       = ""
      protocol     = "TCP"
    }
  }
}
