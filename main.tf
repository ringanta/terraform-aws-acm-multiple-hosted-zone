locals {
  all_domains = concat([var.domain_name.domain], [
    for v in var.subject_alternative_names : v.domain
  ])

  all_zones = concat([var.domain_name.zone], [
    for v in var.subject_alternative_names : v.zone
  ])

  domain_zone_mapping = zipmap(local.all_domains, local.all_zones)

  cert_sans = sort([
    for v in var.subject_alternative_names : v.domain
  ])

  default_tags = {
    ManagedBy = "terraform"
  }
}

data "aws_route53_zone" "self" {
  provider = aws.route53
  for_each = toset(local.all_zones)

  name         = each.value
  private_zone = false
}

resource "aws_acm_certificate" "self" {
  provider = aws.acm

  domain_name               = var.domain_name.domain
  subject_alternative_names = local.cert_sans
  validation_method         = "DNS"

  tags = merge(local.default_tags, var.tags)
}

resource "aws_route53_record" "validation" {
  provider = aws.route53
  for_each = var.validation_set_records ? {
    for dvo in aws_acm_certificate.self.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id         = data.aws_route53_zone.self[local.domain_zone_mapping[each.key]].zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = var.validation_allow_overwrite_records
}

resource "aws_acm_certificate_validation" "self" {
  provider = aws.acm
  count    = var.validate_certificate ? 1 : 0

  certificate_arn         = aws_acm_certificate.self.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
