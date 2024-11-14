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

# Spaceship inputs

variable "sns_topic_arn" {
  type        = string
  description = "ARN of the SNS topic to publish to"
}

variable "ecr_repository_arn" {
  type        = string
  description = "ARN of the ECR repository to pull Lambda images from"
}
