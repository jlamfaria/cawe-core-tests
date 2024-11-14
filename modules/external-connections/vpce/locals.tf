locals {

    tags = {
        Group       = var.group
        Project     = var.project_name
        Environment = var.environment
        Module      = "cawe-core.external-connections"
    }

    supported_azs = {
        for key, svc in data.aws_vpc_endpoint_service.endpoint_service : key =>
        toset(svc.availability_zones)
    }

    selected_subnet_ids = {
        for key, azs in local.supported_azs : key =>
        [for id, subnet in data.aws_subnet.selected : id if contains(azs, subnet.availability_zone)]

    }
}
