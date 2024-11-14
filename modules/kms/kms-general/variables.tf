variable "group" {
  type    = string
  default = "gha"
}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"
  default     = "GitHub Actions"
}

variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
  default     = "dev" # TODO remove as soon as deployment jobs are fixed to pass the value
}

variable "trusted_entities" {
  type        = list(string)
  description = "List of Trusted Entities allowed to assume IAM role"
}

variable "region" {
  type = string
}

variable "multi_region" {
  default = false
}

variable "kms_multi_region" {
  description = "A description of what this variable is used for"
  type        = bool
}

variable "kms_alias_name" {
  description = "A description of what this variable is used for"
  type        = string
}

variable "account_type" {
    type        = string
    description = "Type of account [ADM, ADV, DEF, ORBIT]"
    validation {
        condition = contains(["ADM", "ADV", "DEF", "ORBIT"], var.account_type)
        error_message = "Invalid account type. Must be one of ADM, ADV, DEF, or ORBIT."
    }
}

variable "kms_principals" {
    description = "Principals to allow access to KMS key"
}

