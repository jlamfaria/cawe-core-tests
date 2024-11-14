variable "role_arn" {}
variable "vpc_id" {}

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

variable "vpc_private_subnets" {}
variable "metric_egress_url" {}
variable "metric_injest_url" {}

variable "kms_arn" {
  type        = string
  default     = ""
  description = "KMS ARN to use for encryption"
}
