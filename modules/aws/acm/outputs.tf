output "certificate_arn" {
  value       = aws_acm_certificate.cert.arn
  description = "The ARN of the validated ACM certificate."
}

output "domain_validation_options" {
  value       = aws_acm_certificate.cert.domain_validation_options
  description = "The domain validation options for the ACM certificate."
}
