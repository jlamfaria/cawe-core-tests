variable "vpc_cidr_eu-central-1" {
    type        = string
    description = "VPC CIDR Block"
}

variable "private_subnets_eu-central-1" {
    type        = list(string)
    description = "Private subnets cidrs to use"
}

variable "public_subnets_eu-central-1" {
    type        = list(string)
    description = "Public subnets cidrs to use"
}

variable "vpc_cidr_eu-west-1" {
    type        = string
    description = "VPC CIDR Block"
}

variable "private_subnets_eu-west-1" {
    type        = list(string)
    description = "Private subnets cidrs to use"
}

variable "public_subnets_eu-west-1" {
    type        = list(string)
    description = "Public subnets cidrs to use"
}

variable "vpc_cidr_us-east-1" {
    type        = string
    description = "VPC CIDR Block"
}

variable "private_subnets_us-east-1" {
    type        = list(string)
    description = "Private subnets cidrs to use"
}

variable "public_subnets_us-east-1" {
    type        = list(string)
    description = "Public subnets cidrs to use"
}

variable "vpc_cidr_ap-northeast-2" {
    type        = string
    description = "VPC CIDR Block"
}

variable "private_subnets_ap-northeast-2" {
    type        = list(string)
    description = "Private subnets cidrs to use"
}

variable "public_subnets_ap-northeast-2" {
    type        = list(string)
    description = "Public subnets cidrs to use"
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
