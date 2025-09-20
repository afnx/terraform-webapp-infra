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
  description = "A list of additional domain names for the ACM certificate."
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
