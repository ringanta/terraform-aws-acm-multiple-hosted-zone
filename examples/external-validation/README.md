# Terraform AWS ACM Multiple Hosted Zone Example

This example provides guides on how to use terraform-aws-acm-multiple-hosted-zone with external certificate validation.
You may have a case where some of domains in the certificate is located in different AWS account.
In this case, you can provision the ACM certificate using this module and do the certificate validation in the root project.

This module will ignore registering domain to Route53 when there is no `zone` key in the domain object.

## Usage 

To run this example you need to execute:

```terraform
terraform init
terraform plan -out=tfplan.out
terraform apply tfplan.out
```

Note that this example may create resources that cost money.
Run `terraform destroy` to clean up the resources.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws.example\_org | n/a |
| aws.xendit | n/a |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | n/a |
| certificate\_domains | n/a |

