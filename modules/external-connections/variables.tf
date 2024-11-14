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

variable "eu-central-1_vpc_id" {
    description = ""
}
variable "us-east-1_vpc_id" {
    description = ""
}
variable "ap-northeast-2_vpc_id" {
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
