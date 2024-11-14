variable "role_to_assume" {}
variable "region" {}
variable "region_peering" {}
variable "lambda_runners-macos_function_name" {}
variable "blackbox_tag" {}
variable "prometheus_tag" {}
variable "metric_egress_url" {}
variable "metric_injest_url" {}
variable "admin_cawe_developer" {}
variable "monitoring-exporter_trusted_entities" {}
variable "cluster_oidc_arn" {}
variable "cluster_oidc" {}
variable "reporter_version" {}
variable "allowed_sns_subscriber_aws_orgs" {}


variable "kms_arn" {
  type        = string
  description = "kms arn to encrypt"
}
variable "kms_principals" {
  default = ""
}
variable "account_type" {
  type = string
}
variable "lambda_code" {}

variable "instance_types_x64" {}
variable "instance_types_arm64" {}

# SSM
variable "kms_key_arn" {
  description = "Optional CMK Key ARN to be used for Parameter Store."
  type        = string
  default     = null
}
variable "github_app" {
  description = "GitHub app parameters, see your github app. Ensure the key is the base64-encoded `.pem` file (the output of `base64 app.private-key.pem`, not the content of `private-key.pem`)."
  type = map(object({
    app_id         = string
    client_id      = string
    key_base64     = string
    webhook_secret = string
  }))
}

variable "lambda_webhook_function_name" {
  type        = string
  description = "Lambda function name for webhook"
}

variable "relative_webhook_url" {
  type        = string
  description = "Relative URL for webhook API"
}

variable "lambda_zip" {
  type        = string
  description = "Lambda zip file"
}

variable "lambda_runners_function_name" {
  type        = string
  description = "Lambda function name for runners"
}

variable "lambda_requester_function_name" {
  type        = string
  description = "Lambda function name for requester"
}

# General Project
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


variable "ami_linux_ubuntu_x64_version" {
  type        = string
  description = "CAWE Linux x64 AMI information to filter"
}


variable "ami_linux_ubuntu_arm64_version" {
  type        = string
  description = "CAWE Linux arm64 AMI information to filter"
}

variable "redis_node_type" {}

variable "external_connections" {
  description = "Records to be created for external connections"

  type = list(object({
    modified_date       = string
    expiration_date     = string
    service_type        = string
    ports = list(number)
    customer_short_name = string
    service_short_name  = string
    vpce_service_name   = string
    vpce_region         = string
  }))
}

variable "endpointCn" {
  type        = string
  description = "Endpoint API Gateway CN"
}