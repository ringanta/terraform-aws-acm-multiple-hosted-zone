locals {
  outside_domains = ["example.org", "*.example.org"]

  outside_record_validation = {
    for dvo in module.acm.certificate_domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if contains(local.outside_domains, dvo.domain_name)
  }
}

module "acm" {
  source = "../../"

  providers = {
    aws.acm     = aws
    aws.route53 = aws
  }

  domain_name = {
    zone   = "example.com"
    domain = "example.com"
  }

  subject_alternative_names = [
    {
      zone   = "example.com"
      domain = "*.example.com"
    },
    {
      domain = "example.org"
    },
    {
      domain = "*.example.org"
    }
  ]

  validate_certificate = false

  tags = {
    Name = "ACM request external validation"
  }
}

data "aws_route53_zone" "example_org" {
  provider = aws.example_org

  name         = "example.org"
  private_zone = false
}

resource "aws_route53_record" "example_org_validation" {
  provider = aws.example_org
  for_each = local.outside_record_validation

  zone_id         = data.aws_route53_zone.example_org.zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "self" {
  certificate_arn         = module.acm.certificate_arn
  validation_record_fqdns = [for dvo in module.acm.certificate_domain_validation_options : dvo.resource_record_name]
}
