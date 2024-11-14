variable "lambda_function_name" {}
variable "ssm_github_client_ids" {}
variable "ssm_github_app_ids" {}
variable "ssm_github_app_keys" {}
variable "queue_arn" {}



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
