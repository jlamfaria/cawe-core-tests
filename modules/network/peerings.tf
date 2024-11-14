module "peering_us-east-1" {
    source = "../vpc-peering"

    providers = {
        aws.this = aws.eu-central-1
        aws.peer = aws.us-east-1
    }

    this_vpc_id = module.vpc-eu-central-1.vpc_id
    peer_vpc_id = module.vpc-us-east-1.vpc_id

    auto_accept_peering = true
    name                = "Peer eu-central-1 to us-east-1"

    tags = {
        environment  = var.environment
        group        = var.group
        project_name = var.project_name
    }
}

module "peering_ap-northeast-2" {
    source = "../vpc-peering"

    providers = {
        aws.this = aws.eu-central-1
        aws.peer = aws.ap-northeast-2
    }

    this_vpc_id = module.vpc-eu-central-1.vpc_id
    peer_vpc_id = module.vpc-ap-northeast-2.vpc_id
    name        = "Peer eu-central-1 to ap-northeast-2"


    auto_accept_peering = true

    tags = {
        environment  = var.environment
        group        = var.group
        project_name = var.project_name
    }
}

module "peering_eu-west-1" {
    source = "../vpc-peering"

    providers = {
        aws.this = aws.eu-central-1
        aws.peer = aws.eu-west-1
    }

    this_vpc_id = module.vpc-eu-central-1.vpc_id
    peer_vpc_id = module.vpc-eu-west-1.vpc_id
    name        = "Peer eu-central-1 to eu-west-1"


    auto_accept_peering = true

    tags = {
        environment  = var.environment
        group        = var.group
        project_name = var.project_name
    }
}
