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
