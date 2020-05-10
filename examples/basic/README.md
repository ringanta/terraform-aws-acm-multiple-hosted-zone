# Terraform AWS ACM Multiple Hosted Zone Example

This example provides guides on how to use terraform-aws-acm-multiple-hosted-zone module.

## Usage 

To run this example you need to execute:

```terraform
terraform init
terraform plan -out=tfplan.out
terraform apply tfplan.out
```

Note that this example may create resources that cost money.
Run `terraform destroy` to clean up them.

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
