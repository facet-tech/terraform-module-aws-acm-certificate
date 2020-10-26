output "certificate" {
  value = var.create_certificate ? aws_acm_certificate.certificate[0] : null
  description = "Object containing attributes for the newly created cert."
}
output "route53_validation_records" {
  value = local.create_dns_validation_record_boolean ? aws_route53_record.certificate_validation_record : null
  description = "Object containing attributes for the validation record created on route53. Null if DNS validation is not used."
}
output "certificate_validation" {
  value = var.create_certificate ? aws_acm_certificate_validation.certificate_validation[0] : null
  description = "Object containing attributes for the terraform validation entity."
}