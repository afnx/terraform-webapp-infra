variable "domain_name" {
  type        = string
  description = "The primary domain name for the ACM certificate."
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "A list of additional domain names for the ACM certificate."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the ACM certificate resource."
}
