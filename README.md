## Overview
A Terraform module for creating an AWS ACM Certificate automatically.  Creates a certificate and (if DNS validation is specified) a Route53 entry for validation.

## Dependencies
None

## Code Example
Import the module and retrieve with ```terraform get --update```.
```
module "aws-acm-cert" {
  source      = "git@github.com:facets-io/terraform-module-aws-acm-certificate.git?ref=0.0.1"
  domain_name = "*.playground.nonprod.globalgateway.io"
  route53_hosted_zone_name_for_validation = "playground.nonprod.globalgateway.io"
}

module "aws-acm-cert" {
  source      = "git@github.com:facets-io/terraform-module-aws-acm-certificate.git?ref=0.0.1"
  domain_name = "*.playground.nonprod.globalgateway.io"
}

module "aws-acm-cert" {
  source      = "git@github.com:facets-io/terraform-module-aws-acm-certificate.git?ref=0.0.1"
  route53_hosted_zone_id_for_validation = "Z08141931T0XY4UX97NFI"
  validation_method = "EMAIL"
}
```

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| certificate\_authority\_arn | (Required if creating a private CA issued certificate) ARN of an ACMPCA | `string` | `null` | no |
| certificate\_body | (Required to import a certificate) The certificate's PEM-formatted public key | `string` | `null` | no |
| certificate\_chain | (Optional) The certificate's PEM-formatted chain | `string` | `null` | no |
| certificate\_transparency\_logging\_preference | (Optional) Specifies whether certificate details should be added to a certificate transparency log. Valid values are ENABLED or DISABLED. See https://docs.aws.amazon.com/acm/latest/userguide/acm-concepts.html#concept-transparency for more details. | `string` | `"ENABLED"` | no |
| create\_certificate | (Optional) If set to false no resources will be created. | `bool` | `true` | no |
| dns | Constant representing the value of the 'DNS' validation option. | `string` | `"DNS"` | no |
| domain\_name | (Required unless importing certificate) A domain name for which the certificate should be issued | `string` | `null` | no |
| private\_key | (Required to import a certificate) The certificate's PEM-formatted private key | `string` | `null` | no |
| route53\_hosted\_zone\_id | (Optional) Hosted zone ID, used for validation. Conflicts with route53\_hosted\_zone\_name\_for\_validation. This option should always be used when possbile, as otherwise the code will need to look up the zone id on each run. | `string` | `null` | no |
| route53\_hosted\_zone\_name | (Optional) Hosted zone name, used for validation. Conflicts with route53\_hosted\_zone\_id\_for\_validation. If not set terraform will attempt to lookup the zone name. | `string` | `null` | no |
| subject\_alternative\_names | (Optional) A list of domains that should be SANs in the issued certificate. To remove all elements of a previously configured list, set this value equal to an empty list ([]) or use the terraform taint command to trigger recreation. | `list(string)` | `null` | no |
| tags | (Optional) A map of tags to assign to the resource. | `string` | `null` | no |
| validation\_method | (Optional) Which method to use for validation. DNS or EMAIL are valid, NONE can be used for certificates that were imported into ACM and then into Terraform. If set to EMAIL validation will need to be performed manually. | `string` | `"DNS"` | no |
| validation\_record\_ttl | (Optional) The TTL of the record certificate validation record. Default is 60. | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate | Object containing attributes for the newly created cert. |
| certificate\_validation | Object containing attributes for the terraform validation entity. |
| route53\_validation\_records | Object containing attributes for the validation record created on route53. Null if DNS validation is not used. |