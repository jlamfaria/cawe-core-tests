resource "aws_route53_zone" "default" {
  #checkov:skip=CKV2_AWS_38: "Ensure Domain Name System Security Extensions (DNSSEC) signing is enabled for Amazon Route 53 public hosted zones"
  #checkov:skip=CKV2_AWS_39: "Ensure Domain Name System (DNS) query logging is enabled for Amazon Route 53 hosted zones"
  for_each = toset(var.hosted_zones)

  name = each.key

  vpc {
    vpc_id = data.aws_vpc.public_vpc.id
  }

  vpc {
    vpc_id = data.aws_vpc.private_vpc.id
  }

    vpc {
    vpc_id = data.aws_vpc.private_vpc-1.id
  }
  # Prevent the deletion of associated VPCs after
  # the initial creation. See documentation on
  # aws_route53_zone_association for details
  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_record" "default_records" {
  for_each = toset(var.hosted_zones)

  zone_id = aws_route53_zone.default[each.key].zone_id
  name    = "*"
  type    = "A"

  alias {
    name    = aws_lb.nginx.dns_name
    zone_id = aws_lb.nginx.zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_record" "direct_records_vpc1" {
  count = length(var.dns_prefixes_vpc1)

  zone_id = data.aws_route53_zone.hosted_zones[var.dns_prefixes_vpc1[count.index].hosted_zone].id
  name    = var.dns_prefixes_vpc1[count.index].subdomain
  type    = "A"

  alias {
    name    = aws_lb.direct_vpc1[var.dns_prefixes_vpc1[count.index].load_balancer].dns_name
    zone_id = aws_lb.direct_vpc1[var.dns_prefixes_vpc1[count.index].load_balancer].zone_id

    evaluate_target_health = false
  }
}

resource "aws_route53_vpc_association_authorization" "this_cn-north-1-public" {
  for_each = toset(var.hosted_zones)

  vpc_id  = data.aws_vpc.public_vpc.id
  zone_id = aws_route53_zone.default[each.key].zone_id
}

resource "aws_route53_vpc_association_authorization" "this_cn-north-1-private" {
  for_each = toset(var.hosted_zones)

  vpc_id  = data.aws_vpc.private_vpc.id
  zone_id = aws_route53_zone.default[each.key].zone_id
}

resource "aws_route53_vpc_association_authorization" "this_cn-north-1-private-1" {
  for_each = toset(var.hosted_zones)

  vpc_id  = data.aws_vpc.private_vpc-1.id
  zone_id = aws_route53_zone.default[each.key].zone_id
}