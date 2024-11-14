locals {
  // merge users with ci-bot user as trusted entitites
  trusted_entities           = distinct(module.product.spaceship-team-arns-cn)
  role_to_assume             = var.role_to_assume
}
