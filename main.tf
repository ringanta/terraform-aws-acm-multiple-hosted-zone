locals {
  all_domains = concat([var.domain_name.domain], [
    for v in var.subject_alternative_names: v.domain
  ])
  all_zones = concat([var.domain_name.zone], [
    for v in var.subject_alternative_names: v.zone
  ])
  distinct_zones = distinct(local.all_zones)
  distinct_domains = distinct([
    for domain in local.all_domains: replace(domain, "*.", "")
  ])
  zone_name_to_id_map = zipmap(local.distinct_zones, data.aws_route53_zone.self[*].zone_id)
  domain_to_zone_map = zipmap(local.all_domains, local.all_zones)

  cert_san = reverse(sort([
    for v in var.subject_alternative_names: v.domain
  ]))
  cert_validation_domains = [
    for v in aws_acm_certificate.self.domain_validation_options: tomap(v) if contains(local.distinct_domains, replace(v.domain_name, "*.", ""))
  ]
}

data "aws_route53_zone" "self" {
  count = length(local.distinct_zones)

  name = local.distinct_zones[count.index]
  private_zone = false
}

resource "aws_acm_certificate" "self" {
  domain_name = var.domain_name.domain
  subject_alternative_names = local.cert_san
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    # Workaround for SAN doesn't maintain order
    # See https://github.com/terraform-providers/terraform-provider-aws/issues/8531
    ignore_changes = [subject_alternative_names]
  }
}

resource "aws_route53_record" "validation" {
  count = var.validation_set_records ? length(local.distinct_domains) : 0
  
  zone_id = lookup(local.zone_name_to_id_map, lookup(local.domain_to_zone_map, local.cert_validation_domains[count.index]["domain_name"]))
  name    = local.cert_validation_domains[count.index]["resource_record_name"]
  type    = local.cert_validation_domains[count.index]["resource_record_type"]
  ttl     = 60

  allow_overwrite = var.validation_allow_overwrite_records

  records = [
    local.cert_validation_domains[count.index]["resource_record_value"]
  ]
}

resource "aws_acm_certificate_validation" "self" {
  count = var.validate_certificate ? 1 : 0

  certificate_arn = aws_acm_certificate.self.arn

  validation_record_fqdns = local.cert_validation_domains[*]["resource_record_name"]
}
