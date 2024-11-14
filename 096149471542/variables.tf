variable "role_to_assume" {
  type        = string
  description = ""
}

variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
}

variable "kms_arn" {
  default     = ""
  type        = string
  description = "kms arn to encrypt s3 bucket"
}

#General Project
variable "group" {
  type        = string
  description = "Naming prefix for all resources"
}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"
}

variable "region" {
}

variable "account_type" {
    type        = string
}

variable "kms_principals" {}