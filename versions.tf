terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
      configuration_aliases = [
        aws.acm,
        aws.route53,
      ]
    }
  }

  required_version = ">= 1.0"
}
