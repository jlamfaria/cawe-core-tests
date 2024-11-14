variable "accounts" {
  description = "List of CAWE account by environment and type"

  type = object({
    dev = object({
      default  = string
      advanced = string
    })
    int = object({
      default  = string
      advanced = string
    })
    prd = object({
      default  = string
      advanced = string
    })
  })
}

variable "common_tags" {
  description = "Project common tags"

  type = object({
    environment  = string
    project_name = string
  })
}

variable "account_type" {
    type        = string
}

variable "hosted_zones" {
  description = "List of supported private hosted zones"
  type        = list(string)
}

variable "nginx_ports" {
  description = "List of default Nginx ports to be forwarded"
  type        = list(number)
}

variable "load_balancers_vpc1" {
  description = "List of Network Load Balancers to be created"

  type = list(string)
}

variable "load_balancers_vpc2" {
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

variable "target_groups_vpc2" {
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

variable "dns_prefixes_vpc2" {
  description = "Records to be created for supported private hosted zones"

  type = list(object({
    hosted_zone   = string
    subdomain     = string
    load_balancer = string
  }))
}

variable "vpc_endpoint_service_name" {
  type        = string
  default     = ""
  description = "Endpoint service name for monitoring account"
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

variable "vpc_endpoint_service_name_cdp_tools" {
  type = string

  description = "Endpoint service name for CDP Tools cluster"
}

variable "vpc_endpoint_service_name_code_connected" {
  type = string

  description = "Endpoint service name for Code Connected GitHub"
}


variable "nginx_ami_name" {
  description = "Name of the AMI for Nginx instances"
  type        = string
}

variable "nginx_desired_capacity" {
  description = "Desired number of Nginx instances in the autoscaling group"
  type        = number
}


variable "nginx_instance_type" {
  description = "Instance type for Nginx instances"
  type        = string
}

variable "nginx_max_size" {
  description = "Maximum number of Nginx instances in the autoscaling group"
  type        = number
}

variable "nginx_min_size" {
  description = "Minimum number of Nginx instances in the autoscaling group"
  type        = number
}
