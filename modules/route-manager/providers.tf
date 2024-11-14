terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.advanced-eu-central-1,
        aws.advanced-eu-west-1
      ]
    }
  }
}