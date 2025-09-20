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

variable "domain_name" {
  type        = string
  description = "The primary domain name for the ACM certificate."
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "A list of additional domain names for the ACM certificate."
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default = {
    Environment = "production"
    Owner       = "your-team"
    Project     = "webapp"
  }
}
