variable "domains" {
  description = "List of map of string containing domain name for the certificate and its corresponding hosted zone name"
  type = list(map(string))
}

variable "tags" {
  description = "Key and value pair that will be added as tag"
  type = map(string)
  default = {}
}

variable "validate_certificate" {
  description = "Whether to validate certificate"
  type        = bool
  default     = true
}

variable "validation_set_records" {
  description = "Whether to configure Route53 records for validation"
  type = bool
  default = true
}

variable "validation_allow_overwrite_records" {
  description = "Whether to allow overwrite of Route53 records"
  type        = bool
  default     = true
}
