locals {
  // merge users with ci-bot user as trusted entitites
  environment                = var.environment
  kms_arn                    = var.kms_arn
  vpc_cidr                   = var.vpc_cidr
  vpc_cidr_macOs             = var.vpc_cidr_macOs
  role_to_assume             = var.role_to_assume
}
