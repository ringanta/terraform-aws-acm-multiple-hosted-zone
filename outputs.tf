output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.self.arn
}

output "certificate_domains" {
  description = "List of domain names covered by the certificate"
  value       = concat([aws_acm_certificate.self.domain_name], tolist(aws_acm_certificate.self.subject_alternative_names))
}

output "certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation"
  value       = flatten(aws_acm_certificate.self[*].domain_validation_options)
}
