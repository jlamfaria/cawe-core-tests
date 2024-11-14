variable "lambda_runners_code" {}
variable "lambda_runners_zip" {}

variable "kms_arn" {
    type        = string
    description = "KMS ARN to use for encryption"
}

variable "lambda_function_name" {}
variable "lambda_role_arn" {}
variable "vpc_private_subnets" {}
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

variable "queue_arn" {}
variable "vpc_cidr" {}
variable "node_type" {}
variable "redis_azs" {
    default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}
variable "nodejs_runtime" {
  default = "nodejs20.x"
}

variable "account_type" {
    type        = string
    description = "Type of account [ADM, ADV, DEF, ORBIT]"
    validation {
        condition = contains(["ADM", "ADV", "DEF", "ORBIT"], var.account_type)
        error_message = "Invalid account type. Must be one of ADM, ADV, DEF, or ORBIT."
    }
}
