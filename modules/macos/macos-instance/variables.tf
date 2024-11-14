variable "subnet_id_macOS" {
}
variable "vpc_id" {
}
#variable "ssh_key_name" {}

variable "vpc_cidr_range" {
}

variable "vpc_cidr_range_IRL" {
}


variable "runner_instance_profile_name" {}

variable "region" {}
# Project
variable "group" {
  type        = string
  default     = "gha"
}

variable "project_name" {
  type        = string
  description = "Project Name of this deployment"
  default     = "GitHub Actions"
}


variable "environment" {
  type        = string
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
  default     = "dev" # TODO remove as soon as deployment jobs are fixed to pass the value
}


