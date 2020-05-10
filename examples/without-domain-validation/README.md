# Terraform AWS ACM Multiple Hosted Zone Example

This example provides guides on how to use terraform-aws-acm-multiple-hosted-zone module without creating domain validation records on Route53.
In general it is okay to overwrite domain validation records on Route53.
This example cater to the case in which we don't want to overwrite existing domain validation for any reason.

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

| Name | Version |
|------|---------|
| aws | ~> 2.61 |

## Providers

No provider.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | n/a |
| certificate\_domains | n/a |

