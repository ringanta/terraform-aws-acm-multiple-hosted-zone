# Terraform AWS Certificate Manager (ACM) with Multiple Hosted Zone Module

Terraform module to create an ACM resource that contains domains from multiple Route53 hosted zone.
This module allows provisoning ACM certificate in different AWS account with the Route53.
This module supports terraform version 0.12 only.

## Module versions

- Module version 1.x is in the `master` branch.
- Module version 2.x is in the `v2xx` branch.

Module version 2 introduces breaking change. You can't use version 1.x configuration with module 2.x and vice versa.
To upgrade your existing Terraform project to module version 2, I suggest to provision a new certificate with the same domain name and subject alternatives name. Here is the step would look like:

1. Instantiate `acm-multiple-hosted-zone` version 2 in your existing terraform project.
1. Provision a new ACM certificate using `acm-multiple-hosted-zone` version 2.

    1. Run `terraform plan -out=tfplan.out`.
    1. Run `terraform apply tfplan.out`.
    1. Write down ARN of the newly created ACM certificate.

1. On the consumer side of ACM certificate (For example, ALB), replace old certificate with the new one. This will guarantee a graceful upgrade without downtime.

## Usage

The `domain_name` and `subject_alternative_names` variables consist of map (object) of string and list of map of string. Each object must consist **zone** and **domain** keys.

- The **zone** key contains name of hosted zone where the domain belong. The hosted must be a public one on Route53 in the same AWS account with the requested certificate.
- The **domain** key contains domain name that will be used in the certificate whether in the domain name or subject alternative names section.

```terraform
provider "aws" { }

module "acm" {
    source = "../../"

    providers = {
        aws.acm = aws
        aws.route53 = aws
    }

    domain_name = {
        zone = "example.com"
        domain = "example.com"
    }

    subject_alternative_names = [
        {
            zone = "example.com"
            domain = "*.example.com"
        },
        {
            zone = "example.org"
            domain = "example.org"
        },
        {
            zone =  "example.org"
            domain = "*.example.org"
        }
    ]

    tags = {
        Name = "Test ACM multiple hosted zone"
    }
}
```

## Examples

- [Basic usage example](./examples/basic/)
- [Use existing domain validations records](./examples/without-domain-validation)
- [Different AWS account between ACM and Route53](./examples/different-aws-account)

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws.acm | ~> 3.0 |
| aws.route53 | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_name | Domain name for the ACM certificate | `map(string)` | n/a | yes |
| subject\_alternative\_names | List of subject alternative names for the ACM certificate | `list(map(string))` | n/a | yes |
| tags | Key and value pair that will be added as tag | `map(string)` | `{}` | no |
| validate\_certificate | Whether to validate certificate | `bool` | `true` | no |
| validation\_allow\_overwrite\_records | Whether to allow overwrite of Route53 records | `bool` | `true` | no |
| validation\_set\_records | Whether to configure Route53 records for validation | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | The ARN of the certificate |
| certificate\_domain\_validation\_options | A list of attributes to feed into other resources to complete certificate validation |
| certificate\_domains | List of domain names covered by the certificate |
