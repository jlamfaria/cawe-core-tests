variable "lambda_invoke_arn" {
  type        = string
}

variable "lambda_function_name" {
  type = string
}

variable "relative_webhook_url" {
  type = string
}

variable "kms_arn" {
  type        = string
  default     = ""
  description = "KMS ARN to use for encryption"
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
