# Terraform AWS Certificate Manager (ACM) with Multi Zone Module

Terraform module to create an ACM resource that contains domains from multiple Route53 hosted zone.
ACM validation is using Route53 only.
This module supports terraform version 0.12 only.

## Usage

The `domains` variable consist of list of map (object). Each object must consist **zone** and **domain** keys.

- The **zone** key must contains hosted zone name that must be hosted on Route53 in the same AWS account with the requested certificate.
- The **domain** key contains domain name that will be used in the certificate in the domain name or subject alternative names section.

```terraform
module "acm" {
    source = "../"

    domains = [
        {
            zone = "example.com"
            domain = "example.com"
        },
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
        Name = "Test ACM multiple zone"
    }
}
```

## Examples

- [Basic usage example](./examples/basic/)
- [Use existing domain validations records](./examples/without-domain-validation)

## Conditional domain validation creation

Let's say we want to create a new ACM certificate and there is exiting ACM certificate with overlapping domain name.
Most likely domain validation has been setup on Route53 and it makes the existing domain validation will be overwritten.
Overwritting existing domain validation records might not be a desired behaviour.
To change this behaviour, exclude setting domain validation records on Route53 by configuring the `validation_set_records` variable to **false**.

```terraform
module "acm" {
    source = "../"

    domains = [
        {
            zone = "example.com"
            domain = "example.com"
        },
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

    validation_set_records = false

    tags = {
        Name = "Test ACM multiple zone"
    }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domains | List of map of string containing domain name for the certificate and its corresponding hosted zone name | `list(map(string))` | n/a | yes |
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