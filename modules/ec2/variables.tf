variable "vpc_id" {}
variable "runner_instance_profile_name" {}
variable "vpc_private_subnets" {}
variable "arch" {}
variable "volume_device_name" {}
variable "redis_endpoint" {}
variable "redis_port" {}


variable "ami_version" {
  type        = string
  description = "CAWE AMI information to filter"
}


variable "instance_types" {
  description = "Instance types for x64 platform"
  type        = map(object({
    on_peak_capacity = object({
      desired_capacity = number
    })
    off_peak_capacity = object({
      desired_capacity = number
    })
    list = list(string)
  }))
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
  description = "(Set by pipeline) Used to derive names of AWS resources. Use this to distinguish different enviroments"
}

variable "distribution" {
  type        = string
  description = "Set Linux distribution"
}
