terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      configuration_aliases = [
        aws.eu-west-1,
        aws.us-east-1,
        aws.ap-northeast-2
      ]
    }
  }
}
