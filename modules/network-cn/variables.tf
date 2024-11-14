variable "public_vpc_name" {
    type = string
    description = "The name of the public VPC"

}

variable "private_vpc_name" {
    type = string
    description = "The name of the private VPC"

}

variable "private_vpc_name-1" {
    type = string
    description = "The name of the private VPC"

}

variable "region" {
    type = string
    description = "The region in which the vpcs are created"
}

variable "common_tags" {
  description = "Project common tags"

  type = object({
    environment  = string
    project_name = string
  })
}

variable "nginx_ports" {
  description = "List of default Nginx ports to be forwarded"

  type = list(number)
}

variable "load_balancers_vpc1" {
  description = "List of Network Load Balancers to be created"

  type = list(string)
}

variable "target_groups_vpc1" {
  description = "List of target groups to access BMW intranet services"

  type = list(object({
    subdomain     = string
    hosted_zone   = string
    load_balancer = string
    service_port  = string
    service_ip    = string
  }))
}

variable "dns_prefixes_vpc1" {
  description = "Records to be created for supported private hosted zones"

  type = list(object({
    hosted_zone   = string
    subdomain     = string
    load_balancer = string
  }))
}

variable "nginx_instance_profile_name" {}

variable "instance_type" {
  type        = string
  description = "Instance Type"
}

variable "group" {
  type        = string
  description = "Naming prefix for all resources"
}

variable "autoscaling_name" {
  type        = string
  description = "Name of the autoscaling group"
}

variable "min_nginx_size" {
  description = "Min number of nginx replicas"
  type        = number
}
variable "max_nginx_size" {
  description = "Max number of nginx replicas"
  type        = number
}

variable "desired_capacity" {
  description = "Max number of nginx replicas"
  type        = number
}

variable "worker_connections" {
  type        = number
  default     = 32767
  description = "number of connections to be allowed to one nginx instance"
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

variable "ami_name" {
  description = "The name to give to the copied AMI."
  type        = string
}

variable "ami_name_prefix" {
  description = "The prefix to be added to the AMI name"
  type        = string
  default     = "transit"
}

variable "hosted_zones" {
  description = "List of supported private hosted zones"

  type = list(string)
}