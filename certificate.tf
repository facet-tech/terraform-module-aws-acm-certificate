locals {
  is_dns_validation                      = var.validation_method == var.dns
  create_dns_validation_record_boolean   = local.is_dns_validation && var.create_certificate
  is_hosted_zone_id_provided             = var.route53_hosted_zone_id != "" && var.route53_hosted_zone_id != null
  should_lookup_hosted_zone_id           = var.create_certificate && (!local.is_hosted_zone_id_provided) && local.is_dns_validation ? 1 : 0
  hosted_zone_name_for_lookup            = var.route53_hosted_zone_name == "" || var.route53_hosted_zone_name == null ? trim(regex("\\..*", var.domain_name), ".") : var.route53_hosted_zone_name
  validation_hosted_zone_id              = local.should_lookup_hosted_zone_id == 1 ? data.aws_route53_zone.zone[0].zone_id : var.route53_hosted_zone_id
  create_certificate                     = var.create_certificate ? 1 : 0
  # Wildcard certificates (eg. *.nonprod.globalgateway.io) have the same certificate validation record as certs without the '*.' (eg. nonprod.globalgateway.io)
  # The following logic prevents us from creating two identical record resources
  number_of_validation_records_to_create = length(distinct([for san in concat(var.subject_alternative_names, [var.domain_name]): trim(san, "*.")]))
}

resource "aws_acm_certificate" "certificate" {
  count                     = local.create_certificate
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  options {
    certificate_transparency_logging_preference = var.certificate_transparency_logging_preference
  }
  private_key               = var.private_key
  certificate_body          = var.certificate_body
  certificate_chain         = var.certificate_chain
  certificate_authority_arn = var.certificate_authority_arn
  #tags                      = var.tags
}
data "aws_route53_zone" "zone" {
  count        = local.should_lookup_hosted_zone_id
  name         = local.hosted_zone_name_for_lookup
  private_zone = false
}
resource "aws_route53_record" "certificate_validation_record" {
  count   = local.create_dns_validation_record_boolean ? local.number_of_validation_records_to_create : 0
  name    = aws_acm_certificate.certificate[0].domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.certificate[0].domain_validation_options[count.index].resource_record_type
  zone_id = local.validation_hosted_zone_id
  records = [aws_acm_certificate.certificate[0].domain_validation_options[count.index].resource_record_value]
  ttl     = var.validation_record_ttl
}

# Note that the certificate validation object will be updated on every run. See https://github.com/terraform-providers/terraform-provider-aws/issues/8714
resource "aws_acm_certificate_validation" "certificate_validation" {
  count                   = local.create_certificate
  certificate_arn         = aws_acm_certificate.certificate[0].arn
  validation_record_fqdns = local.is_dns_validation ? aws_acm_certificate.certificate[0].domain_validation_options[*].resource_record_name : null
}