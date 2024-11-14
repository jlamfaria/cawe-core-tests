data "terraform_remote_state" "state_from_advanced" {
  backend   = "s3"
  workspace = "092228957173"

  config = {
    bucket               = "ca-remote-state-prd"
    workspace_key_prefix = "ca-accounts"
    key                  = "terraform.tfstate"
    region               = "eu-central-1"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-central-1:831308554080:key/d3c2a829-56ca-41e4-916b-a0fc13606f34"
    dynamodb_table       = "ca-remote-state-prd-dynamodb"

    assume_role = {
      role_arn = "arn:aws:iam::831308554080:role/cawe/cawe-developer"
    }
  }
}

data "terraform_remote_state" "state_from_admin" {
  backend   = "s3"
  workspace = "831308554080"

  config = {
    bucket               = "ca-remote-state-prd"
    workspace_key_prefix = "ca-accounts"
    key                  = "terraform.tfstate"
    region               = "eu-central-1"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-central-1:831308554080:key/d3c2a829-56ca-41e4-916b-a0fc13606f34"
    dynamodb_table       = "ca-remote-state-prd-dynamodb"

    assume_role = {
      role_arn = "arn:aws:iam::831308554080:role/cawe/cawe-developer"
    }
  }
}

data "aws_vpc" "vpc1" {
  tags = {
    Name = "cawe-private-vpc1"
  }
}

data "aws_subnet" "vpc1_subnet" {
  vpc_id = data.aws_vpc.vpc1.id
  filter {
    name = "tag:Name"
    values = ["intranet-0"]
  }
}