variable "lambda_function_name" {

}
variable "kms_arn" {}
variable "lambda_runners_hash" {}

variable "lambda_webhook_code" {}


variable "lambda_webhook_zip" {

}

variable "lambda_role_arn" {

}

variable "linux_queue_url" {}
variable "macos_queue_url" {
    type = string
    default = ""
}

variable "vpc_id" {}

variable "vpc_private_subnets" {}

variable "relative_webhook_url" {}

variable "webhook_execution_arn" {}

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

variable "nodejs_runtime" {
  default = "nodejs20.x"
}

variable "endpointCn" {
  type        = string
  description = "Endpoint API Gateway CN"
  default = ""
}
