variable "cloud_provider" {
  description = "Cloud provider to use (aws, gcp, both)."
  type        = string
  default     = "aws"
}

variable "region" {
  description = "Region to deploy resources."
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
