provider "aws" {
  region = "eu-central-1"

  assume_role {
    role_arn = var.role_to_assume
  }
}

provider "grafana" {
  url  = "https://spaceship.bmwgroup.net/grafana/"
  auth = "${module.grafana-basic-auth-username.secret_content}:${module.grafana-basic-auth-password.secret_content}"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "2.18.0"
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
