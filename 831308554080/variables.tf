variable "role_to_assume" {
  type        = string
  description = ""
}

variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
}

variable "destination_ids_nginx" {
  type = list(string)
}

variable "ami_name_nginx" {}

variable "source_ami_id_nginx" {}

variable "kms_arn" {
  default     = ""
  type        = string
  description = "kms arn to encrypt s3 bucket"
}

variable "vpc_cidr" {}

variable "vpc_subnet_count" {}

variable "vpc_cidr_macOs" {}

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
  default = "eu-central-1"
}

variable "account_type" {
}
variable "kms_principals" {
}
