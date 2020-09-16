module "acm" {
  source = "../../"

  providers = {
    aws.route53 = aws.production
    aws.acm     = aws.staging
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
      zone   = "example.org"
      domain = "example.org"
    },
    {
      zone   = "example.org"
      domain = "*.example.org"
    }
  ]

  tags = {
    Name = "ACM certificate with multiple hosted zones and multiple AWS accounts"
  }
}
