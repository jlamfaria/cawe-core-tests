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

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR Block"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnets cidrs to use"
}
variable "public_subnets" {
  type        = list(string)
  description = "Public subnets cidrs to use"
}

variable "kms_arn" {
  type        = string
  default     = ""
  description = "KMS ARN to use for encryption"
}
