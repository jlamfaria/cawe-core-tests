variable "role_name" {
  type        = string
  description = "Role name"
}

variable "policy_prefix" {
  type        = string
  description = "Prefix to append to the policy name"
  default     = "cawe-policy"
}

variable "trusted_entities" {
  type        = list(string)
  description = "List of Trusted Entities allowed to assume IAM role"
}

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

variable "account_type" {
    type        = string
    description = "Type of account [ADM, ADV, DEF, ORBIT]"
    validation {
        condition = contains(["ADM", "ADV", "DEF", "ORBIT"], var.account_type)
        error_message = "Invalid account type. Must be one of ADM, ADV, DEF, or ORBIT."
    }
}

variable "oidc_provider_url" {
  type        = string
  default = "https://code.connected.bmw/_services/token"
  description = "GitHub OIDC provider URL"
}