variable "domain_name" {
  type        = string
  description = "(Required unless importing certificate) A domain name for which the certificate should be issued"
  default     = null
}
variable "validation_method" {
  type        = string
  description = "(Optional) Which method to use for validation. DNS or EMAIL are valid, NONE can be used for certificates that were imported into ACM and then into Terraform. If set to EMAIL validation will need to be performed manually."
  default     = "DNS"
}
variable "certificate_transparency_logging_preference" {
  type        = string
  description = "(Optional) Specifies whether certificate details should be added to a certificate transparency log. Valid values are ENABLED or DISABLED. See https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency for more details."
  default     = "ENABLED"
}
variable "private_key" {
  type        = string
  description = "(Required to import a certificate) The certificate's PEM-formatted private key"
  default     = null
}
variable "certificate_body" {
  type        = string
  description = "(Required to import a certificate) The certificate's PEM-formatted public key"
  default     = null
}
variable "certificate_chain" {
  type        = string
  description = "(Optional) The certificate's PEM-formatted chain"
  default     = null
}
variable "certificate_authority_arn" {
  type        = string
  description = "(Required if creating a private CA issued certificate) ARN of an ACMPCA"
  default     = null
}
variable "subject_alternative_names" {
  type        = list(string)
  description = "(Optional) A list of domains that should be SANs in the issued certificate. To remove all elements of a previously configured list, set this value equal to an empty list ([]) or use the terraform taint command to trigger recreation."
  default     = null
}
variable "tags" {
  type        = string
  description = "(Optional) A map of tags to assign to the resource."
  default     = null
}

variable "route53_hosted_zone_name" {
  type        = string
  description = "(Optional) Hosted zone name, used for validation. Conflicts with route53_hosted_zone_id_for_validation. If not set terraform will attempt to lookup the zone name."
  default     = null
}
variable "route53_hosted_zone_id" {
  type        = string
  description = "(Optional) Hosted zone ID, used for validation. Conflicts with route53_hosted_zone_name_for_validation. This option should always be used when possbile, as otherwise the code will need to look up the zone id on each run."
  default     = null
}
variable "validation_record_ttl" {
  type        = number
  description = "(Optional) The TTL of the record certificate validation record. Default is 60."
  default     = 60
}
variable "create_certificate" {
  type        = bool
  default     = true
  description = "(Optional) If set to false no resources will be created."
}
variable "dns" {
  type        = string
  description = "Constant representing the value of the 'DNS' validation option."
  default     = "DNS"
}