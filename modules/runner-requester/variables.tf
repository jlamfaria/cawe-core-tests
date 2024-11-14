variable "lambda_function_name" {
  type        = string
  description = "AWS Lambda function name"
}

variable "kms_arn" {
  type        = string
  description = "KMS ARN"
}

variable "lambda_code" {
  type        = string
  description = "Path to the lambda code"
}

variable "lambda_zip" {
  type        = string
  description = "Path to the lambda zip file"
}

variable "lambda_role_arn" {
  type        = string
  description = "Lambda role ARN"
}

variable "lambda_runners_hash" {
  type        = string
  description = "Hash of Runner Lambda code"
}

variable "linux_queue_url" {
  type        = string
  description = "Linux Queue URL"
}

variable "macos_queue_url" {
  type        = string
  description = "MacOS Queue URL"
}

variable "vpc_id" {}

variable "vpc_private_subnets" {}

variable "relative_webhook_url" {
  type = string
}

variable "webhook_execution_arn" {
  type = string
}

variable "api_webhook_id" {
  type        = string
  description = "API Gateway webhook ID"
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
  description = "Environment of this deployment"
}

variable "nodejs_runtime" {
  type        = string
  description = "NodeJS runtime version"
  default     = "nodejs20.x"
}
