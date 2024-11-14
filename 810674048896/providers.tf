provider "aws" {
  region = "eu-central-1"
  alias  = "eu-central-1"

  assume_role {
    role_arn = var.role_to_assume
  }
}

provider "aws" {
  region = "eu-central-1"

  assume_role {
    role_arn = var.role_to_assume
  }
}

provider "aws" {
  alias  = "eu-west-1"
  region = "eu-west-1"

  assume_role {
    role_arn = var.role_to_assume
  }
}

provider "aws" {
  alias  = "aws-ireland" #TODO delete after some sprints (ensure proper state migration)
  region = "eu-west-1"

  assume_role {
    role_arn = var.role_to_assume
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  assume_role {
    role_arn = var.role_to_assume
  }
}

provider "aws" {
  alias  = "ap-northeast-2"
  region = "ap-northeast-2"

  assume_role {
    role_arn = var.role_to_assume
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.37.0"
    }
  }

  backend "s3" {
    bucket               = "ca-remote-state-prd"
    key                  = "terraform.tfstate"
    workspace_key_prefix = "ca-accounts"
    region               = "eu-central-1"
    role_arn             = "arn:aws:iam::831308554080:role/cawe/cawe-developer"
    encrypt              = true
    kms_key_id           = "arn:aws:kms:eu-central-1:831308554080:key/d3c2a829-56ca-41e4-916b-a0fc13606f34"
    dynamodb_table       = "ca-remote-state-prd-dynamodb"
  }
}


