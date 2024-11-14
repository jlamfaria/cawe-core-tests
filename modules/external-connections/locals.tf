locals {

    external_connections_emea = [for item in var.external_connections : item if item.vpce_region == "eu-central-1"]
    external_connections_us   = [for item in var.external_connections : item if item.vpce_region == "us-east-1"]
    external_connections_kr   = [for item in var.external_connections : item if item.vpce_region == "ap-northeast-2"]
}
