variable "policy_prefix" {
  type        = string
  description = "Prefix to append to the policy name"
  default     = "cawe-policy"
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

variable "cluster_oidc_arn" {}
variable "cluster_oidc" {}
variable "adv_role" {
  default = ""
}
