provider "aws" {
    region = "cn-north-1"

    assume_role {
        role_arn = var.role_to_assume
    }
}

terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.31.0"
        }
    }

    backend "s3" {
        bucket               = "cawe-remote-state-prod"
        key                  = "terraform.tfstate"
        workspace_key_prefix = "ca-accounts"
        region               = "cn-north-1"
        role_arn             = "arn:aws-cn:iam::096149471542:role/cawe/cawe-developer"
        encrypt              = true
        kms_key_id           = "arn:aws-cn:kms:cn-north-1:096149471542:key/31bdc21e-04b9-4e37-a210-5bd6bad4d9e8"
        dynamodb_table       = "cawe-remote-state-prod-dynamodb"
    }
}
