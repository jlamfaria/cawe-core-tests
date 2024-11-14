terraform {
    required_providers {
        github = {
            source  = "integrations/github"
            version = "~> 6.2.1"
        }
    }

    backend "s3" {
        bucket               = "ca-remote-state-prd"
        key                  = "terraform.tfstate"
        workspace_key_prefix = "github"
        region               = "eu-central-1"
        role_arn             = "arn:aws:iam::831308554080:role/cawe/cawe-developer"
        encrypt              = true
        kms_key_id           = "arn:aws:kms:eu-central-1:831308554080:key/d3c2a829-56ca-41e4-916b-a0fc13606f34"
        dynamodb_table       = "ca-remote-state-prd-dynamodb"
    }
}

provider "github" {
    alias    = "orbit-actions-atc"
    base_url = "https://atc-github.azure.cloud.bmw"
    owner    = "orbit-actions"
}

provider "github" {
    alias    = "cicd-atc"
    base_url = "https://atc-github.azure.cloud.bmw"
    owner    = "cicd"
}
