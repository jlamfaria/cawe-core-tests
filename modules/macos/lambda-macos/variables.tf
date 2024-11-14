variable "vpc_id" {}
variable "lambda_function_name" {}
variable "lambda_runners_hash" {}
variable "lambda_runners_zip" {}


variable "lambda_runners-macos_code" {}
variable "lambda_role_arn" {}
variable "queue_arn" {}
variable "vpc_private_subnets" {}
variable "kms_arn" {}


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
