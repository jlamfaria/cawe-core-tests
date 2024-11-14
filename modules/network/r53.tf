resource "aws_route53_zone" "spaceship-bmw" {
    name = "spaceship.bmw"
    vpc {
        vpc_id = module.vpc-eu-central-1.vpc_id
    }

    # Prevent the deletion of associated VPCs after
    # the initial creation. See documentation on
    # aws_route53_zone_association for details
    # https://github.com/hashicorp/terraform-provider-aws/issues/14872
    lifecycle {
        ignore_changes = [vpc]
    }
}

resource "aws_route53_zone_association" "ap-northeast-2" {
    zone_id    = aws_route53_zone.spaceship-bmw.zone_id
    vpc_id     = module.vpc-ap-northeast-2.vpc_id
    vpc_region = "ap-northeast-2"
}

resource "aws_route53_zone_association" "us-east-1" {
    zone_id    = aws_route53_zone.spaceship-bmw.zone_id
    vpc_id     = module.vpc-us-east-1.vpc_id
    vpc_region = "us-east-1"
}

resource "aws_route53_zone_association" "eu-west-1" {
    zone_id    = aws_route53_zone.spaceship-bmw.zone_id
    vpc_id     = module.vpc-eu-west-1.vpc_id
    vpc_region = "eu-west-1"
}
