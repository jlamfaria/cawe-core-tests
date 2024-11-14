variable "role_to_assume" {
    type        = string
    description = "IAM Role to assume on terraform"
}

variable "lambda_code" {}

variable "instance_types_x64" {}
variable "instance_types_arm64" {}
variable "admin_cawe_developer" {}

# SSM
variable "kms_key_arn" {
    description = "Optional CMK Key ARN to be used for Parameter Store."
    type        = string
    default     = null
}
variable "github_app" {
    description = "GitHub app parameters, see your github app. Ensure the key is the base64-encoded `.pem` file (the output of `base64 app.private-key.pem`, not the content of `private-key.pem`)."
    type        = map(object({
        app_id         = string
        client_id      = string
        key_base64     = string
        webhook_secret = string
    }))
}

### API GATEWAY
variable "lambda_webhook_function_name" {
    type = string
}

variable "relative_webhook_url" {
    type = string
}

variable "lambda_zip" {}

### Runners Lambda

variable "lambda_runners_function_name" {
    type = string
}

#General Project

variable "account_type" {
}
variable "group" {
    type        = string
    description = "Naming prefix for all resources"
}

variable "common_tags" {
    description = "Project common tags"

    type = object({
        environment  = string
        project_name = string
    })
}

variable "hosted_zones" {
    description = "List of supported private hosted zones"
    type        = list(string)
}

variable "project_name" {
    type        = string
    description = "Project Name of this deployment"
}

variable "region" {
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

variable "external_connections" {
    description = "Records to be created for external connections"

    type = list(object({
        modified_date       = string
        expiration_date     = string
        service_type        = string
        ports               = list(number)
        customer_short_name = string
        service_short_name  = string
        vpce_service_name   = string
        vpce_region         = string
    }))
}

variable "kms_principals" {}

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

variable "nginx_ports" {
  description = "List of default Nginx ports to be forwarded"

  type = list(number)
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

variable "load_balancers_vpc1" {
  description = "List of Network Load Balancers to be created"

  type = list(string)
}

variable "dns_prefixes_vpc1" {
  description = "Records to be created for supported private hosted zones"

  type = list(object({
    hosted_zone   = string
    subdomain     = string
    load_balancer = string
  }))
}