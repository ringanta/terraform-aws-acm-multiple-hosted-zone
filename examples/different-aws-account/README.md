# Terraform AWS ACM Multiple Hosted Zone Example

This example provides guides on how to use terraform-aws-acm-multiple-hosted-zone module involving multiple AWS accounts.
To be precise, the ACM certificate will be provisioned in a certain AWS account while the domain are hosted in another AWS account.

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

No requirements.

## Providers

No provider.

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| certificate\_arn | n/a |
| certificate\_domains | n/a |
