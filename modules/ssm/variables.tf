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

# Project
variable "group" {
  type        = string
  description = "Naming prefix for all resources"
}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"
  default     = "GitHub Actions"
}

# General
variable "region" {
  type        = string
  description = "AWS region to use for resources"
  default     = "eu-central-1"
}

variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
  default     = "dev"
}



