terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
        }
        sops = {
            source  = "carlpett/sops"
            version = "1.0.0"
        }
    }
}
