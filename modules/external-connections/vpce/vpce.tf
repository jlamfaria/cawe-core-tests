resource "aws_vpc_endpoint" "endpoint_connection" {
    for_each           = {for index, con in var.external_connections : con.vpce_service_name => con}
    vpc_id             = data.aws_vpc.vpc.id
    service_name       = each.value.vpce_service_name
    vpc_endpoint_type  = "Interface"
    security_group_ids = [aws_security_group.endpoint_connection_sg[each.value.vpce_service_name].id]

    subnet_ids = local.selected_subnet_ids[each.value.vpce_service_name]

    private_dns_enabled = false

    tags = merge({
        Name            = "External Connections - ${each.value.customer_short_name} - ${each.value.service_short_name} (${each.value.service_type})"
        Requested_Ports = join(",", each.value.ports)
        Expiration_Date = each.value.expiration_date
        Modified_Date   = each.value.modified_date
        Customer_Name   = each.value.customer_short_name
        Service_Name    = each.value.service_short_name
        Service_Type    = each.value.service_type
    }, local.tags)

}

resource "aws_security_group" "endpoint_connection_sg" {
    for_each    = {for index, con in var.external_connections : con.vpce_service_name => con}
    name        = "External Connections - ${each.value.customer_short_name} - ${each.value.service_short_name}"
    description = "Allow traffic for ${each.value.customer_short_name} - ${each.value.service_short_name}"
    vpc_id      = data.aws_vpc.vpc.id

    egress {
        description = "All Outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    dynamic "ingress" {
        for_each = each.value.ports

        content {
            description = "Allow port ${ingress.value}"
            from_port   = ingress.value
            to_port     = ingress.value
            protocol    = "tcp"
            cidr_blocks = ["10.19.0.0/16"]
        }
    }

    tags = merge({
        Name            = "Security Group for ${each.value.customer_short_name} - ${each.value.service_short_name} (${each.value.service_type})"
        Requested_Ports = join(",", each.value.ports)
        Expiration_Date = each.value.expiration_date
        Modified_Date   = each.value.modified_date
        Customer_Name   = each.value.customer_short_name
        Service_Name    = each.value.service_short_name
        Service_Type    = each.value.service_type
    }, local.tags)
}

resource "aws_route53_record" "external_connection_record" {
    for_each = {for index, con in var.external_connections : con.vpce_service_name => con}

    zone_id = var.hosted_zone_id
    name    = "${each.value.service_short_name}.${each.value.customer_short_name}.${each.value.vpce_region}.${var.hosted_zone_name}"
    type    = "A"

    alias {
        name                   = aws_vpc_endpoint.endpoint_connection[each.key].dns_entry[0].dns_name
        zone_id                = aws_vpc_endpoint.endpoint_connection[each.key].dns_entry[0].hosted_zone_id
        evaluate_target_health = true
    }

}
