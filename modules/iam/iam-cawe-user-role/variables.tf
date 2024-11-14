variable "role_name" {
  type        = string
  description = "Role name"
}

variable "policy_prefix" {
  type        = string
  description = "Prefix to append to the policy name"
  default     = "cawe-policy"
}

variable "bucket_tools_arn" {}

variable "ecr_arn" {
  type        = string
}

variable "trusted_entities" {
  type        = list(string)
  description = "List of Trusted Entities allowed to assume IAM role"
}

variable "account_type" {
    type        = string
    description = "Type of account [ADM, ADV, DEF, ORBIT]"
    validation {
        condition = contains(["ADM", "ADV", "DEF", "ORBIT"], var.account_type)
        error_message = "Invalid account type. Must be one of ADM, ADV, DEF, or ORBIT."
    }
}
