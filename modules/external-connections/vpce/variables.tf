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

    validation {
        condition = length([
            for o in var.external_connections : true
            if contains(["database", "api"], o.service_type)
        ]) == length(var.external_connections)
        error_message = "Service_type must be  one of [database, api]."
    }

    validation {
        condition = length([
            for o in var.external_connections : true
            if contains(["eu-central-1", "ap-northeast-2", "us-east-1"], o.vpce_region)
        ]) == length(var.external_connections)
        error_message = "Vpce_region must be one of [eu-central-1, ap-northeast-2, us-east-1]."
    }
}

variable "vpc_id" {
    description = ""
}

variable "hosted_zone_id" {
    description = ""
}

variable "hosted_zone_name" {
    description = ""
}

variable "project_name" {
    description = ""
}
variable "environment" {
    description = ""
}
variable "group" {}
