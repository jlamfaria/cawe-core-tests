variable "policy_prefix" {
  type        = string
  description = "Prefix to append to the policy name"
  default     = "cawe-policy"
}
variable "bucket_arn" {
  type        = string
  description = "Arn to give access to"
}

variable "trusted_entities" {
  type        = list(string)
  description = "List of Trusted Entities allowed to assume IAM role"
}
# Project
variable "group" {
  type        = string
  description = "Naming prefix for all resources"

}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"

}

variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
}

variable "kms_arns" {}

variable "account_type" {
    type        = string
    description = "Type of account [ADM, ADV, DEF, ORBIT]"
    validation {
        condition = contains(["ADM", "ADV", "DEF", "ORBIT"], var.account_type)
        error_message = "Invalid account type. Must be one of ADM, ADV, DEF, or ORBIT."
    }
}
