variable "vpc_id" {
  type        = string
  description = "vpc id of transit account"
}

variable "subnets_id" {
  type        = list(string)
  description = "subnet id of intranet"
}

variable "targets" {
  type = map(object({
    target_service_ip   = string
    target_service_port = number
    listener_port       = number
  }))
  description = "The target intranet service and the respective IPs"
}


